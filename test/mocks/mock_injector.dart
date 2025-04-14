import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/di/injector.dart';
import 'package:kagi_news/ui/controller/kagi_news_controller.dart';

import '../mocks/repository_mocks.mocks.dart';

class MockInjector {
  static void setup() {
    Injector.reset();

    final container = Injector.container;

    container.registerSingleton<KagiNewsRepository>(
      (_) => MockKagiNewsRepository(),
    );

    container.registerFactory<KagiNewsController>(
      (c) => KagiNewsController(repository: c.resolve<KagiNewsRepository>()),
    );
  }
}
