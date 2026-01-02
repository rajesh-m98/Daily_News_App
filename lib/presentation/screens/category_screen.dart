import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/article_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import 'article_detail_screen.dart';

/// Category Screen
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedCategory = 'general';

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
      category: _selectedCategory,
      language: languageProvider.apiLanguageCode,
    );
  }

  Future<void> _refresh() async {
    final newsProvider = context.read<NewsProvider>();
    final languageProvider = context.read<LanguageProvider>();

    await newsProvider.refresh(
      category: _selectedCategory,
      language: languageProvider.apiLanguageCode,
    );
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        children: [
          // Category Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ApiConstants.categories.length,
              itemBuilder: (context, index) {
                final category = ApiConstants.categories[index];
                final iconCode = AppConstants.categoryIcons[category];
                final colorValue = AppConstants.categoryColors[category];

                return CategoryChip(
                  category: category,
                  isSelected: _selectedCategory == category,
                  onTap: () => _onCategoryChanged(category),
                  icon: iconCode != null
                      ? IconData(iconCode, fontFamily: 'MaterialIcons')
                      : null,
                  color: colorValue != null ? Color(colorValue) : null,
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Articles List
          Expanded(
            child: Consumer<NewsProvider>(
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
                  return EmptyStateWidget(
                    message: 'No $_selectedCategory news available',
                    icon: Icons.category,
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: newsProvider.articles.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final article = newsProvider.articles[index];
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
