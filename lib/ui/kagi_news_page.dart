import 'package:flutter/material.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';
import 'package:kagi_news/di/injector.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:kagi_news/ui/category_details_tab.dart';
import 'package:kagi_news/ui/kagi_news_controller.dart';

class KagiNewsPage extends StatefulWidget {
  late final KagiNewsController _controller;

  KagiNewsPage({
    super.key,
    KagiNewsController? controller,
  }) {
    _controller =
        controller ?? Injector.container.resolve<KagiNewsController>();
  }

  @override
  _KagiNewsPageState createState() => _KagiNewsPageState();
}

class _KagiNewsPageState extends State<KagiNewsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    widget._controller.categoriesNotifier.dispose();
    widget._controller.categoryDetailsNotifiers.forEach((key, notifier) {
      notifier.dispose();
    });
    super.dispose();
  }

  Future<void> _refreshData() async {
    await widget._controller.fetchCategories(forceRefresh: true);

    final result = widget._controller.categoriesNotifier.value;
    if (result != null && result.isSuccess) {
      await Future.wait(result.data!.categories
          .map((category) => widget._controller.fetchCategoryDetails(
                category.file,
                forceRefresh: true,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.app.title),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ValueListenableBuilder<Result<KagiNewsCategoriesResponse>?>(
          valueListenable: widget._controller.categoriesNotifier,
          builder: (context, result, _) {
            if (result == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (result.error != null) {
              return _buildErrorWidget('${result.error}');
            }

            final categoriesResponse = result.data!;
            final categories = categoriesResponse.categories;
            if (categories.isEmpty) {
              return _buildEmptyWidget(t.app.noCategoriesAvailable);
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
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 50,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                SizedBox(height: 24),
                Text(
                  'Pull down to refresh',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyWidget(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 50,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                SizedBox(height: 24),
                Text(
                  'Pull down to refresh',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
