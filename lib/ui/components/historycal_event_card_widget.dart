import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoricalEventCard extends StatelessWidget {
  final OnThisDayItem item;

  const HistoricalEventCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPastCentury = double.parse(item.year) < 2000;
    final cardColor =
        isPastCentury
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
                  right: BorderSide(color: theme.colorScheme.primary, width: 2),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Html(
                  data: item.htmlContent,
                  onAnchorTap: (String? url, _, __) {
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
}
