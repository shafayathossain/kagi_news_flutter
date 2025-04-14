import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/ui/controller/kagi_news_controller.dart';
import 'package:kagi_news/ui/components/news_detail_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryDetailsTab extends StatefulWidget {
  final KagiNewsController controller;
  final String fileName;
  final String categoryName;

  const CategoryDetailsTab({
    Key? key,
    required this.controller,
    required this.fileName,
    required this.categoryName,
  }) : super(key: key);

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
    if (widget.controller.categoryDetailsNotifiers[widget.fileName] == null) {
      return _buildScrollableEmptyState();
    } else {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshCategoryDetails,
        child: ValueListenableBuilder(
          valueListenable:
              widget.controller.categoryDetailsNotifiers[widget.fileName]!,
          builder: (context, snapshot, _) {
            if (snapshot == null) {
              return _buildLoadingState();
            }

            if (snapshot.error != null) {
              return _buildErrorState(snapshot.error!);
            }

            final detailsResponse = snapshot.data!;
            final clusters = detailsResponse.clusters;
            final onThisDayItems = detailsResponse.onThisDayItems;

            if (clusters?.isEmpty ??
                true && onThisDayItems != null && onThisDayItems.isNotEmpty) {
              return buildOnThisDayList(onThisDayItems!);
            }

            if (clusters != null && clusters.isNotEmpty) {
              return buildClustersList(clusters);
            }

            return _buildScrollableEmptyState();
          },
        ),
      );
    }
  }

  Widget buildClustersList(List<NewsCluster> clusters) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: clusters.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey.withOpacity(0.5),
      ),
      itemBuilder: (context, index) {
        final cluster = clusters[index];
        return ListTile(
          title: Text(cluster.title),
          subtitle: cluster.shortSummary.isNotEmpty
              ? Text(
                  cluster.shortSummary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          leading: cluster.emoji.isNotEmpty
              ? Text(cluster.emoji, style: const TextStyle(fontSize: 24))
              : null,
          onTap: () {
            _showNewsDetailBottomSheet(context, cluster);
          },
        );
      },
    );
  }

  Widget buildOnThisDayList(List<OnThisDayItem> items) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "On This Day in History",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildHistoricalEventCard(item, theme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 50,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
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
                Text(errorMessage),
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

  Widget _buildScrollableEmptyState() {
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
                Text('No news available for ${widget.categoryName}'),
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

  Widget _buildHistoricalEventCard(OnThisDayItem item, ThemeData theme) {
    final isPastCentury = double.parse(item.year) < 2000;
    final cardColor = isPastCentury
        ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.3);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 0,
      color: cardColor,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Year column with vertical line
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.year,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (item.type.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Chip(
                        label: Text(
                          item.type,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),
            // Event content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Html(
                  data: item.htmlContent,
                  onAnchorTap: (
                    String? url,
                    _,
                    __,
                  ) {
                    if (url != null) {
                      launchUrl(Uri.parse(url));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewsDetailBottomSheet(BuildContext context, NewsCluster cluster) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewsDetailBottomSheet(cluster: cluster),
    );
  }
}
