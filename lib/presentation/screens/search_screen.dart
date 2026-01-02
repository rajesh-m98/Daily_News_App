import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart';
import 'article_detail_screen.dart';

/// Search Screen
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;

    final newsProvider = context.read<NewsProvider>();
    final languageProvider = context.read<LanguageProvider>();

    await newsProvider.searchArticles(
      query: query,
      language: languageProvider.apiLanguageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textInputAction: TextInputAction.search,
          onSubmitted: _search,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _search(_searchController.text),
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (newsProvider.hasError) {
            return ErrorDisplayWidget(
              message: newsProvider.error ?? 'Search failed',
              onRetry: () => _search(_searchController.text),
            );
          }

          if (!newsProvider.hasArticles) {
            return EmptyStateWidget(
              message: _searchController.text.isEmpty
                  ? 'Enter a search term to find news'
                  : 'No results found for "${_searchController.text}"',
              icon: Icons.search_off,
            );
          }

          return ListView.builder(
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
                      builder: (_) => ArticleDetailScreen(article: article),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
