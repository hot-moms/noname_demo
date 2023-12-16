import 'dart:async';

import 'package:flutter/foundation.dart'
    show ChangeNotifier, FlutterError, PlatformDispatcher, ValueListenable;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter/widgets.dart'
    show WidgetsBinding, WidgetsFlutterBinding;
import 'package:meta/meta.dart';

part 'initialize_dependencies.dart';

typedef InitializationProgressTuple = ({int progress, String message});
typedef InitializationProgressListenable
    = ValueListenable<InitializationProgressTuple>;

abstract class InitializationExecutor<MutableDependencies extends Object,
        Dependencies extends Object>
    with
        ChangeNotifier,
        InitializeDependencies<MutableDependencies, Dependencies>
    implements InitializationProgressListenable {
  @mustBeOverridden
  Dependencies Function(MutableDependencies mutableDependencies) get freeze;

  @override
  @mustBeOverridden
  MutableDependencies Function() get create;

  @mustBeOverridden
  @override
  List<
      (
        String,
        FutureOr<void> Function(
          MutableDependencies dependencies,
        )
      )> get initializationSteps;

  /// Ephemerally initializes the app and prepares it for use.
  Future<Dependencies>? _$activeInitialization;

  @override
  InitializationProgressTuple get value => _value;
  InitializationProgressTuple _value = (progress: 0, message: '');

  /// Initializes the app and prepares it for use.
  Future<Dependencies> init({
    bool deferFirstFrame = false,
    List<DeviceOrientation>? orientations,
    void Function(int progress, String message)? onProgress,
    void Function(Dependencies dependencies, Duration elapsed)? onSuccess,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) =>
      _$activeInitialization ??= Future<Dependencies>(() async {
        late final WidgetsBinding binding;
        final stopwatch = Stopwatch()..start();
        void notifyProgress(int progress, String message) {
          _value = (progress: progress.clamp(0, 100), message: message);
          onProgress?.call(_value.progress, _value.message);
          notifyListeners();
        }

        notifyProgress(0, 'Starting Initialization');
        try {
          binding = WidgetsFlutterBinding.ensureInitialized();
          if (deferFirstFrame) binding.deferFirstFrame();

          await _catchExceptions(onError: onError);
          if (orientations != null) {
            await SystemChrome.setPreferredOrientations(orientations);
          }

          final dependencies = await _$initializeDependencies(
            onProgress: notifyProgress,
            freeze: freeze,
          ).timeout(const Duration(minutes: 5));

          notifyProgress(100, 'Done');
          onSuccess?.call(dependencies, stopwatch.elapsed);
          return dependencies;
        } on Object catch (error, stackTrace) {
          onError?.call(error, stackTrace);
          rethrow;
        } finally {
          stopwatch.stop();

          binding.addPostFrameCallback((_) {
            if (deferFirstFrame) binding.allowFirstFrame();
          });
          _$activeInitialization = null;
        }
      });

  Future<void> _catchExceptions({
    required void Function(Object, StackTrace)? onError,
  }) async {
    try {
      PlatformDispatcher.instance.onError = (error, stackTrace) {
        onError?.call(
          error,
          stackTrace,
        );
        return true;
      };

      final sourceFlutterError = FlutterError.onError;
      FlutterError.onError = (final details) {
        onError?.call(
          details.exception,
          details.stack ?? StackTrace.current,
        );
        // FlutterError.presentError(details);
        sourceFlutterError?.call(details);
      };
    } on Object catch (error, stackTrace) {
      onError?.call(error, stackTrace);
    }
  }
}
