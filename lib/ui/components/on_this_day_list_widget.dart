import 'package:flutter/material.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/ui/components/historycal_event_card_widget.dart';

class OnThisDayListWidget extends StatelessWidget {
  const OnThisDayListWidget({
    required this.items,
    super.key,
  });

  final List<OnThisDayItem> items;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
            itemBuilder: (_, index) {
              final item = items[index];

              return HistoricalEventCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}
