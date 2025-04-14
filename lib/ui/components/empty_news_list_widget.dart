import 'package:flutter/material.dart';

class EmptyNewsListWidget extends StatelessWidget {
  const EmptyNewsListWidget({
    super.key,
    required this.categoryName,
  });

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 - 50,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text('No news available for ${categoryName}'),
                const SizedBox(height: 24),
                const Text(
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