import 'package:background_fetch/background_fetch.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/di/injector.dart';

@pragma('vm:entry-point')
class BackgroundFetchService {
  static const String TAG = "BackgroundFetchService";
  static const int FETCH_INTERVAL = 240; // 4 hours in minutes

  @pragma('vm:entry-point')
  static Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
    final String taskId = task.taskId;
    final bool isTimeout = task.timeout;

    if (isTimeout) {
      await BackgroundFetch.finish(taskId);

      return;
    }

    try {
      Injector.setup();
      final repository = Injector.container.resolve<KagiNewsRepository>();
      await repository.sync();
    } catch (e) {}

    await BackgroundFetch.finish(taskId);
  }

  static Future<void> initialize() async {
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: FETCH_INTERVAL,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      _onBackgroundFetch,
      _onBackgroundFetchTimeout,
    );

    await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  static void _onBackgroundFetch(String taskId) {
    try {
      final repository = Injector.container.resolve<KagiNewsRepository>();
      repository.sync();
    } catch (e) {}

    BackgroundFetch.finish(taskId);
  }

  static void _onBackgroundFetchTimeout(String taskId) {
    BackgroundFetch.finish(taskId);
  }
}
