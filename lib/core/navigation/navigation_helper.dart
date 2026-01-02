import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/article_model.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/article_detail_screen.dart';

/// Navigation Helper
///
/// Provides unified navigation methods that work with both:
/// - Simple Navigator (default)
/// - GoRouter (when enabled)
///
/// Usage:
/// ```dart
/// // Navigate to search
/// NavigationHelper.toSearch(context);
///
/// // Navigate to article detail
/// NavigationHelper.toArticleDetail(context, article);
/// ```
class NavigationHelper {
  /// Check if GoRouter is being used
  static bool _isUsingGoRouter(BuildContext context) {
    try {
      GoRouter.of(context);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Navigate to Search Screen
  static void toSearch(BuildContext context) {
    if (_isUsingGoRouter(context)) {
      context.push('/search');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      );
    }
  }

  /// Navigate to Article Detail Screen
  static void toArticleDetail(BuildContext context, Article article) {
    if (_isUsingGoRouter(context)) {
      context.push('/article-detail', extra: article);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        ),
      );
    }
  }

  /// Navigate to Settings Screen
  static void toSettings(BuildContext context) {
    if (_isUsingGoRouter(context)) {
      context.push('/settings');
    } else {
      // Settings is in bottom nav, no need to navigate
      // But keeping this for future use
    }
  }

  /// Go back
  static void goBack(BuildContext context) {
    if (_isUsingGoRouter(context)) {
      context.pop();
    } else {
      Navigator.pop(context);
    }
  }

  /// Navigate to Home
  static void toHome(BuildContext context) {
    if (_isUsingGoRouter(context)) {
      context.go('/home');
    } else {
      // Already on home with bottom nav
    }
  }

  /// Navigate to Language Selection
  static void toLanguageSelection(BuildContext context) {
    if (_isUsingGoRouter(context)) {
      context.go('/language-selection');
    } else {
      // Use Navigator replacement
      // This is typically called from splash screen
    }
  }
}
