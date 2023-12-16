part of 'initialization.dart';

@internal
mixin InitializeDependencies<MutableDependencies extends Object,
    Dependencies extends Object> {
  /// Initializes the app and returns a [Dependencies] object
  @protected
  Future<Dependencies> _$initializeDependencies({
    void Function(int progress, String message)? onProgress,
    required Dependencies Function(MutableDependencies mutableDependencies)
        freeze,
  }) async {
    final steps = initializationSteps;
    final dependencies = create();
    final totalSteps = steps.length;
    for (var currentStep = 0; currentStep < totalSteps; currentStep++) {
      final step = steps[currentStep];
      final percent = (currentStep * 100 ~/ totalSteps).clamp(10, 100);
      onProgress?.call(percent, step.$1);

      await step.$2(dependencies);
    }
    return freeze(dependencies);
  }

  MutableDependencies Function() get create;

  List<
      (
        String,
        FutureOr<void> Function(
          MutableDependencies dependencies,
        )
      )> get initializationSteps;
}

/*
      <(String, _InitializationStep)>[
        (
          'Platform pre-initialization',
          (_) => $platformInitialization(),
        ),
        (
          'Firebase Core initialization',
          (_) async => Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              )
        ),
        (
          'Google Recaptcha',
          (_) => GRecaptchaV3.ready('6Ld9aEEmAAAAAAmVN8WSbd-0_fTHf85spZ_-8q_j')
        ),
        (
          'Shared preferences',
          (deps) async =>
              deps.sharedPreferences = await SharedPreferences.getInstance()
        ),
        (
          'Preferences driver',
          (deps) => deps.preferencesDriver = PreferencesDriver(
                sharedPreferences: deps.sharedPreferences!,
                // observers: [const PreferencesDriverObserver()],
              )
        ),
        (
          'Settings initialization',
          (deps) => deps.settingsRepository = SettingsRepository(
                settingsDao: SettingsDao(deps.preferencesDriver!),
              )
        ),
        (
          'Rest Client',
          (deps) => deps.restClient = RestClientBase(
                baseUrl: 'https://ms-geologistic-cementum-dev.geoservice24.ru',
              ),
        ),
        (
          'Authentication Repository',
          (deps) => deps.authRepository = AuthRepository(
                restClient: deps.restClient!,
                authDao: AuthDao(deps.preferencesDriver!),
              )
        ),
        (
          'Map Notifier',
          (deps) => deps.mapDao = MapDao(deps.preferencesDriver!)
        ),
        (
          'Dispatcher Repository',
          (deps) => deps.dispatcherRepository = DispatcherRepository(
                dataProvider:
                    DispatcherDataProvider(restClient: deps.restClient!),
              )
        )
      ]
       */
