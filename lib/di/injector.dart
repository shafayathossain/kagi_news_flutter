import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kiwi/kiwi.dart';
import 'package:kagi_news/data/datasource/local/app_database.dart';
import 'package:kagi_news/data/datasource/local/category_details_dao.dart';
import 'package:kagi_news/data/datasource/local/kagi_news_local_data_source.dart';
import 'package:kagi_news/data/datasource/network/dio_client.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository_impl.dart';
import 'package:kagi_news/ui/controller/kagi_news_controller.dart';

class Injector {
  static final KiwiContainer container = KiwiContainer();

  static void setup() {
    _registerNetworkServices();
    _registerLocalServices();
    _registerRepository();
    _registerControllers();
  }

  static void _registerNetworkServices() {
    container.registerSingleton((c) => DioClient());

    container.registerSingleton<KagiNewsApiService>(
      (c) => KagiNewsApiService(dioClient: c.resolve<DioClient>()),
    );
  }

  static void _registerLocalServices() {
    container.registerSingleton((c) => AppDatabase());

    container.registerSingleton<CategoryDetailsDao>(
      (c) => c.resolve<AppDatabase>().categoryDetailsDao,
    );

    container.registerSingleton<KagiNewsLocalDataSource>(
      (c) => KagiNewsLocalDataSource(
        categoryDetailsDao: c.resolve<CategoryDetailsDao>(),
      ),
    );
  }

  static void _registerRepository() {
    container.registerSingleton<KagiNewsRepository>(
      (c) => KagiNewsRepositoryImpl(
        localDataSource: c.resolve<KagiNewsLocalDataSource>(),
        apiService: c.resolve<KagiNewsApiService>(),
      ),
    );
  }

  static void _registerControllers() {
    container.registerFactory<KagiNewsController>(
      (c) => KagiNewsController(repository: c.resolve<KagiNewsRepository>()),
    );
  }

  static void reset() {
    container.clear();
  }
}
