import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart';
import 'article_detail_screen.dart';

/// Local News Screen
class LocalNewsScreen extends StatefulWidget {
  const LocalNewsScreen({super.key});

  @override
  State<LocalNewsScreen> createState() => _LocalNewsScreenState();
}

class _LocalNewsScreenState extends State<LocalNewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNews();
    });
  }

  Future<void> _loadNews() async {
    final newsProvider = context.read<NewsProvider>();
    final languageProvider = context.read<LanguageProvider>();

    await newsProvider.fetchLocalNews(
      language: languageProvider.apiLanguageCode,
    );
  }

  Future<void> _refresh() async {
    final newsProvider = context.read<NewsProvider>();
    final languageProvider = context.read<LanguageProvider>();

    await newsProvider.fetchLocalNews(
      language: languageProvider.apiLanguageCode,
      forceRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<NewsProvider>(
          builder: (context, newsProvider, child) {
            final city = newsProvider.currentCity ?? 'Local';
            return Text('$city News');
          },
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading && newsProvider.localArticles.isEmpty) {
            return const ShimmerLoadingList();
          }

          if (newsProvider.hasError && newsProvider.localArticles.isEmpty) {
            return ErrorDisplayWidget(
              message: newsProvider.error ?? 'Unable to fetch local news',
              onRetry: _loadNews,
            );
          }

          if (newsProvider.localArticles.isEmpty) {
            return EmptyStateWidget(
              message: newsProvider.currentCity != null
                  ? 'No local news available for ${newsProvider.currentCity}'
                  : 'Unable to detect your location',
              icon: Icons.location_off,
              onAction: newsProvider.currentCity == null ? _loadNews : null,
              actionLabel: 'Retry',
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: Column(
              children: [
                // Location Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Showing news for ${newsProvider.currentCity}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Articles List
                Expanded(
                  child: ListView.builder(
                    itemCount: newsProvider.localArticles.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final article = newsProvider.localArticles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ArticleDetailScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
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
