import 'package:flutter/material.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailBottomSheet extends StatelessWidget {
  final NewsCluster cluster;

  const NewsDetailBottomSheet({required this.cluster, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDragHandle(theme, context),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          _buildHeader(context),
                          const Divider(height: 24),
                          _buildSummarySection(context),
                          _buildKeyPointsSection(context),
                          _buildPerspectivesSection(context),
                          _buildQuoteSection(context),
                          _buildHistoricalBackgroundSection(context),
                          _buildBusinessAngleSection(context),
                          _buildInternationalReactionsSection(context),
                          _buildArticlesSection(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDragHandle(ThemeData theme, BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.scrim.withValues(alpha: 0.0),
              elevation: 2,
            ),
            child: Text(t.app.close, style: const TextStyle(fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cluster.emoji.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 12, top: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  cluster.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cluster.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    backgroundColor: theme.colorScheme.secondary.withValues(
                      alpha: 0.2,
                    ),
                    label: Text(
                      cluster.category,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (cluster.location.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                cluster.location,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    if (cluster.shortSummary.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.summary),
        const SizedBox(height: 8),
        Text(cluster.shortSummary, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildKeyPointsSection(BuildContext context) {
    if (cluster.talkingPoints.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.keyPoints),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  cluster.talkingPoints
                      .map((point) => _buildKeyPointItem(context, point))
                      .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildKeyPointItem(BuildContext context, String point) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, color: theme.colorScheme.secondary, size: 20),
          const SizedBox(width: 4),
          Expanded(child: Text(point)),
        ],
      ),
    );
  }

  Widget _buildPerspectivesSection(BuildContext context) {
    if (cluster.perspectives.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.differentPerspectives),
        const SizedBox(height: 8),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cluster.perspectives.length,
            itemBuilder:
                (_, index) =>
                    _PerspectiveCard(perspective: cluster.perspectives[index]),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuoteSection(BuildContext context) {
    if (cluster.quote.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.notableQuotes),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${cluster.quote}"',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.2,
                  ),
                ),
                if (cluster.quoteAuthor.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _buildQuoteAttribution(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuoteAttribution(BuildContext context) {
    final theme = Theme.of(context);

    if (cluster.quoteSourceUrl.isNotEmpty) {
      return InkWell(
        onTap: () async {
          final Uri url = Uri.parse(cluster.quoteSourceUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
        child: Text(
          '— ${cluster.quoteAuthor}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Text(
      '— ${cluster.quoteAuthor}',
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  Widget _buildHistoricalBackgroundSection(BuildContext context) {
    if (cluster.historicalBackground.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.historicalBackground),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(cluster.historicalBackground),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBusinessAngleSection(BuildContext context) {
    if (cluster.businessAngleText.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.businessAngle),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cluster.businessAngleText),
                if (cluster.businessAnglePoints.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  ...cluster.businessAnglePoints.map(
                    (point) => _buildBusinessPoint(context, point),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBusinessPoint(BuildContext _, String point) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(point)),
        ],
      ),
    );
  }

  Widget _buildInternationalReactionsSection(BuildContext context) {
    if (cluster.internationalReactions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.internationalReactions),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cluster.internationalReactions.length,
          itemBuilder: (context, index) {
            return _buildReactionCard(
              context,
              cluster.internationalReactions[index],
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReactionCard(BuildContext context, String reaction) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(reaction, style: theme.textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildArticlesSection(BuildContext context) {
    if (cluster.articles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, t.app.relatedArticles),
        const SizedBox(height: 12),
        ...cluster.articles.map(
          (article) => buildArticleCard(context, article),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget buildArticleCard(BuildContext context, Article article) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          final Uri url = Uri.parse(article.link);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.isNotEmpty)
              Stack(
                children: [
                  Image.network(
                    article.image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(height: 0),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (article.domain.isNotEmpty) ...[
                        Icon(
                          Icons.public,
                          size: 14,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          flex: 3,
                          child: Text(
                            article.domain,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (!article.image.isNotEmpty)
                        Expanded(
                          flex: 5,
                          child: Text(
                            article.date,
                            textAlign: TextAlign.end,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerspectiveCard extends StatelessWidget {
  final Perspective perspective;

  const _PerspectiveCard({required this.perspective});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    perspective.text,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              if (perspective.sources.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("Source: "),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                            perspective.sources.first.url,
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft,
                          backgroundColor: Colors.transparent,
                          overlayColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: Text(
                          perspective.sources.first.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              perspective.sources.first.url.isNotEmpty
                                  ? TextStyle(
                                    color: theme.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
