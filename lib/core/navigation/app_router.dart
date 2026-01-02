import 'package:daily_news/data/models/article_model.dart';
import 'package:daily_news/presentation/screens/article_detail_screen.dart';
import 'package:daily_news/presentation/screens/home_screen.dart';
import 'package:daily_news/presentation/screens/language_selection_screen.dart';
import 'package:daily_news/presentation/screens/search_screen.dart';
import 'package:daily_news/presentation/screens/settings_screen.dart';
import 'package:daily_news/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App Router Configuration using GoRouter
class AppRouter {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String localNews = '/local-news';
  static const String search = '/search';
  static const String articleDetail = '/article-detail';
  static const String settings = '/settings';

  /// Create GoRouter instance
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      debugLogDiagnostics: true,
      routes: [
        // Splash Screen
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Language Selection Screen
        GoRoute(
          path: languageSelection,
          name: 'language-selection',
          builder: (context, state) => const LanguageSelectionScreen(),
        ),

        // Home Screen (with bottom navigation)
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Search Screen
        GoRoute(
          path: search,
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),

        // Article Detail Screen
        GoRoute(
          path: articleDetail,
          name: 'article-detail',
          builder: (context, state) {
            final article = state.extra as Article;
            return ArticleDetailScreen(article: article);
          },
        ),

        // Settings Screen (if you want it as a separate route)
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],

      // Error handling
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.uri.path}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(home),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension methods for easier navigation
extension GoRouterExtension on BuildContext {
  /// Navigate to home screen
  void goToHome() => go(AppRouter.home);

  /// Navigate to language selection
  void goToLanguageSelection() => go(AppRouter.languageSelection);

  /// Navigate to search screen
  void goToSearch() => push(AppRouter.search);

  /// Navigate to article detail
  void goToArticleDetail(Article article) {
    push(AppRouter.articleDetail, extra: article);
  }

  /// Navigate to settings
  void goToSettings() => push(AppRouter.settings);

  /// Go back
  void goBack() => pop();
}
