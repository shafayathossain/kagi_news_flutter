import 'package:flutter/material.dart';
import 'package:kagi_news/data/datasource/local/kagi_news_local_data_source.dart';
import 'package:kagi_news/data/datasource/network/dio_client.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:kagi_news/ui/category_details_tab.dart';
import 'package:kagi_news/ui/kagi_news_controller.dart';

class KagiNewsPage extends StatefulWidget {
  late final KagiNewsController _controller;

  KagiNewsPage({
    super.key,
    KagiNewsController? controller,
  }) {
    if (controller == null) {
      final repository = KagiNewsRepository(
        localDataSource: KagiNewsLocalDataSource.withDefaultDb(),
        apiService: KagiNewsApiService(dioClient: DioClient()),
      );
      _controller = KagiNewsController(repository: repository);
    } else {
      _controller = controller;
    }
  }

  @override
  _KagiNewsPageState createState() => _KagiNewsPageState();
}

class _KagiNewsPageState extends State<KagiNewsPage> {
  @override
  void dispose() {
    widget._controller.categoriesNotifier.dispose();
    widget._controller.categoryDetailsNotifiers.forEach((key, notifier) {
      notifier.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app.title),
      ),
      body: ValueListenableBuilder<Result<KagiNewsCategoriesResponse>?>(
        valueListenable: widget._controller.categoriesNotifier,
        builder: (context, result, _) {
          if (result == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.error != null) {
            return Center(child: Text('${result.error}'));
          }

          final categoriesResponse = result.data!;
          final categories = categoriesResponse.categories;
          if (categories.isEmpty) {
            return Center(child: Text(t.app.noCategoriesAvailable));
          }

          return DefaultTabController(
            length: categories.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: categories.map((cat) => Tab(text: cat.name)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: categories.map(
                      (category) {
                        return CategoryDetailsTab(
                          controller: widget._controller,
                          fileName: category.file,
                          categoryName: category.name,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
