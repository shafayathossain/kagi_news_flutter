import 'package:flutter/material.dart';
import 'package:kagi_news/ui/kagi_news_controller.dart';

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
  @override
  void initState() {
    super.initState();
    widget.controller.fetchCategoryDetails(widget.fileName);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.categoryDetailsNotifiers[widget.fileName] == null) {
      return getEmptyClustersWidget();
    } else {
      return ValueListenableBuilder(
        valueListenable:
            widget.controller.categoryDetailsNotifiers[widget.fileName]!,
        builder: (context, snapshot, _) {
          if (snapshot == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.error != null) {
            return Center(
              child: Text('Error loading ${widget.categoryName} details'),
            );
          }

          final detailsResponse = snapshot.data!;
          final clusters = detailsResponse.clusters;

          if (clusters.isEmpty) {
            return getEmptyClustersWidget();
          }
          return ListView.builder(
            itemCount: clusters.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(clusters[index].title),
              );
            },
          );
        },
      );
    }
  }

  Center getEmptyClustersWidget() {
    return Center(
      child: Text('No news available for ${widget.categoryName}'),
    );
  }
}
