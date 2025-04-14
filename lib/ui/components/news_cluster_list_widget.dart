import 'package:flutter/material.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';

class NewsClusterListWidget extends StatelessWidget {
  final List<NewsCluster> clusters;
  final Function(BuildContext, NewsCluster) onClusterTap;

  const NewsClusterListWidget({
    required this.clusters,
    required this.onClusterTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: clusters.length,
      separatorBuilder:
          (_, __) => Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
      itemBuilder: (context, index) {
        final cluster = clusters[index];

        return ListTile(
          title: Text(cluster.title),
          subtitle:
              cluster.shortSummary.isNotEmpty
                  ? Text(
                    cluster.shortSummary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                  : null,
          leading:
              cluster.emoji.isNotEmpty
                  ? Text(cluster.emoji, style: const TextStyle(fontSize: 24))
                  : null,
          onTap: () => onClusterTap(context, cluster),
        );
      },
    );
  }
}
