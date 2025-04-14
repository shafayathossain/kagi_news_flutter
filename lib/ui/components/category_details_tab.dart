// ignore_for_file: avoid_returning_widgets
import 'package:flutter/material.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';
import 'package:kagi_news/ui/components/category_details_error_widget.dart';
import 'package:kagi_news/ui/components/empty_news_list_widget.dart';
import 'package:kagi_news/ui/components/news_cluster_list_widget.dart';
import 'package:kagi_news/ui/components/news_detail_bottom_sheet.dart';
import 'package:kagi_news/ui/components/news_list_loading_state.dart';
import 'package:kagi_news/ui/components/on_this_day_list_widget.dart';
import 'package:kagi_news/ui/controller/kagi_news_controller.dart';

class CategoryDetailsTab extends StatefulWidget {
  final KagiNewsController controller;
  final String fileName;
  final String categoryName;

  const CategoryDetailsTab({
    required this.controller,
    required this.fileName,
    required this.categoryName,
    super.key,
  });

  @override
  State<CategoryDetailsTab> createState() => _CategoryDetailsTabState();
}

class _CategoryDetailsTabState extends State<CategoryDetailsTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    widget.controller.fetchCategoryDetails(widget.fileName);
  }

  Future<void> _refreshCategoryDetails() async {
    await widget.controller.fetchCategoryDetails(
      widget.fileName,
      forceRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = widget.controller.categoryDetailsNotifiers[widget.fileName];
    if (notifier == null) {
      return EmptyNewsListWidget(categoryName: widget.categoryName);
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshCategoryDetails,
      child: ValueListenableBuilder(
        valueListenable: notifier,
        builder: (_, snapshot, __) => _buildContent(snapshot),
      ),
    );
  }

  Widget _buildContent(Result<NewsCategoryDetailsResponse>? snapshot) {
    if (snapshot == null) {
      return NewsListLoadingState();
    }

    if (snapshot.error != null) {
      return CategoryDetailsErrorWidget(errorMessage: snapshot.error!);
    }

    final detailsResponse = snapshot.data;
    final clusters = detailsResponse!.clusters;
    final onThisDayItems = detailsResponse!.onThisDayItems;

    // If clusters are empty (or null) but there are On This Day items, show the on-this-day widget.
    if ((clusters == null || clusters.isEmpty) &&
        onThisDayItems != null &&
        onThisDayItems.isNotEmpty) {
      return OnThisDayListWidget(items: onThisDayItems);
    }

    // If clusters are not empty, show the list widget.
    if (clusters != null && clusters.isNotEmpty) {
      return NewsClusterListWidget(
        clusters: clusters,
        onClusterTap: _showNewsDetailBottomSheet,
      );
    }

    // Default to the empty state if none of the above conditions match.
    return EmptyNewsListWidget(categoryName: widget.categoryName);
  }

  void _showNewsDetailBottomSheet(BuildContext context, NewsCluster cluster) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewsDetailBottomSheet(cluster: cluster),
    );
  }
}
