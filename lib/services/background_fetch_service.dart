import 'package:background_fetch/background_fetch.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository_impl.dart';
import 'package:kagi_news/di/injector.dart';

@pragma('vm:entry-point')
class BackgroundFetchService {
  static const String TAG = "BackgroundFetchService";
  static const int FETCH_INTERVAL = 240; // 4 hours in minutes

  @pragma('vm:entry-point')
  static void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;

    if (isTimeout) {
      BackgroundFetch.finish(taskId);
      return;
    }

    try {
      Injector.setup();
      final repository = Injector.container.resolve<KagiNewsRepository>();
      await repository.sync();
    } catch (e) {}

    BackgroundFetch.finish(taskId);
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
          requiredNetworkType: NetworkType.ANY),
      _onBackgroundFetch,
      _onBackgroundFetchTimeout,
    );

    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  static void _onBackgroundFetch(String taskId) async {
    try {
      final repository = Injector.container.resolve<KagiNewsRepository>();
      final result = await repository.sync();

      if (result.isSuccess) {
      } else {}
    } catch (e) {}

    BackgroundFetch.finish(taskId);
  }

  static void _onBackgroundFetchTimeout(String taskId) async {
    BackgroundFetch.finish(taskId);
  }
}
