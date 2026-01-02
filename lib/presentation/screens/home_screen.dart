import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/news_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart';
import '../../core/navigation/navigation_helper.dart'; // Unified navigation
import 'category_screen.dart';
import 'local_news_screen.dart';
import 'settings_screen.dart';

/// Home Screen with Bottom Navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HeadlinesTab(),
    const CategoryScreen(),
    const LocalNewsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Local',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

/// Headlines Tab
class HeadlinesTab extends StatefulWidget {
  const HeadlinesTab({super.key});

  @override
  State<HeadlinesTab> createState() => _HeadlinesTabState();
}

class _HeadlinesTabState extends State<HeadlinesTab> {
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

    await newsProvider.fetchTopHeadlines(
      language: languageProvider.apiLanguageCode,
    );
  }

  Future<void> _refresh() async {
    final newsProvider = context.read<NewsProvider>();
    final languageProvider = context.read<LanguageProvider>();

    await newsProvider.refresh(language: languageProvider.apiLanguageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily News'),
        actions: [
          // Search Button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => NavigationHelper.toSearch(context),
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading && !newsProvider.hasArticles) {
            return const ShimmerLoadingList();
          }

          if (newsProvider.hasError && !newsProvider.hasArticles) {
            return ErrorDisplayWidget(
              message: newsProvider.error ?? 'Something went wrong',
              onRetry: _loadNews,
            );
          }

          if (!newsProvider.hasArticles) {
            return const EmptyStateWidget(
              message: 'No news available at the moment',
              icon: Icons.newspaper,
            );
          }

          // Lazy loading with pagination
          return RefreshIndicator(
            onRefresh: _refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // Load more when user reaches 80% of the list
                if (!newsProvider.isLoadingMore &&
                    newsProvider.hasMore &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent * 0.8) {
                  newsProvider.loadMoreArticles();
                }
                return false;
              },
              child: ListView.builder(
                itemCount:
                    newsProvider.articles.length +
                    (newsProvider.hasMore ? 1 : 0),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemBuilder: (context, index) {
                  // Show loading indicator at the end
                  if (index == newsProvider.articles.length) {
                    return const LoadingIndicator();
                  }

                  final article = newsProvider.articles[index];
                  return ArticleCard(
                    article: article,
                    onTap: () =>
                        NavigationHelper.toArticleDetail(context, article),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
