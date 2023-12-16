import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noname_demo/src/core/logger/logger.dart';
import 'package:noname_demo/src/feature/app/widget/app_runner.dart';
import 'package:noname_demo/src/feature/dependencies/initialization/initialization_dev.dart';

void main() async => logger.runLogging(
      () => runZonedGuarded<void>(
        () async {
          final dependencies = await DependencyInitializationDev().init(
            deferFirstFrame: true,
            onSuccess: (dependencies, time) => logger.info('Initialization took $time (${time.inMilliseconds} ms)'),
            onProgress: (progress, message) => logger.info('$message ($progress%)'),
          );

          runApp(
            AppRunner(dependencies: dependencies),
          );
        },
        (e, s) => logger.error(
          'Error $e during initialization',
          error: e,
          stackTrace: s,
        ),
      ),
      const LogOptions(),
    );
