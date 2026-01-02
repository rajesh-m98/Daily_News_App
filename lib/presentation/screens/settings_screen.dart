import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/news_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/translation_service.dart';

/// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SizedBox(height: 8.h),

          // Language Section
          _buildSectionHeader(context, 'Language'),
          const _LanguageSelector(),

          SizedBox(height: 16.h),

          // Theme Section
          _buildSectionHeader(context, 'Appearance'),
          const _ThemeToggle(),

          SizedBox(height: 16.h),

          // Cache Section
          _buildSectionHeader(context, 'Data'),
          const _ClearCacheButton(),

          SizedBox(height: 16.h),

          // About Section
          _buildSectionHeader(context, 'About'),
          const _AboutSection(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

/// Language Selector
class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(languageProvider.languageName),
            trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
            onTap: () => _showLanguageDialog(context),
          ),
        );
      },
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    final languageProvider = context.read<LanguageProvider>();
    final newsProvider = context.read<NewsProvider>();
    final translationService = TranslationService();

    final selectedLanguage = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.supportedLanguages.length,
            itemBuilder: (context, index) {
              final entry = AppConstants.supportedLanguages.entries.elementAt(
                index,
              );
              final code = entry.key;
              final name = entry.value;
              final isSelected = languageProvider.isLanguageSelected(code);

              return RadioListTile<String>(
                title: Text(name),
                value: code,
                groupValue: languageProvider.selectedLanguage,
                onChanged: (value) => Navigator.pop(context, value),
                selected: isSelected,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedLanguage != null &&
        selectedLanguage != languageProvider.selectedLanguage) {
      // Show loading
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // Download translation model if needed
      if (selectedLanguage != 'en') {
        await translationService.downloadLanguageModel(selectedLanguage);
      }

      // Update language
      await languageProvider.setLanguage(selectedLanguage);

      // Clear cache and reload news
      await newsProvider.clearCache();

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Language updated. Pull to refresh news.'),
          ),
        );
      }
    }
  }
}

/// Theme Toggle
class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            title: const Text('Dark Mode'),
            subtitle: Text(themeProvider.isDarkMode ? 'Enabled' : 'Disabled'),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),
        );
      },
    );
  }
}

/// Clear Cache Button
class _ClearCacheButton extends StatelessWidget {
  const _ClearCacheButton();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListTile(
        leading: const Icon(Icons.delete_outline),
        title: const Text('Clear Cache'),
        subtitle: const Text('Remove cached articles'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
        onTap: () => _clearCache(context),
      ),
    );
  }

  Future<void> _clearCache(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'Are you sure you want to clear all cached articles?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<NewsProvider>().clearCache();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache cleared successfully')),
        );
      }
    }
  }
}

/// About Section
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: Text(AppConstants.appVersion),
          ),
          Divider(height: 1.h),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('About'),
            subtitle: const Text('Daily News - Stay Informed, Stay Ahead'),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.newspaper, size: 40.sp, color: Colors.white),
      ),
      children: [
        SizedBox(height: 16.h),
        const Text(
          'A professional Flutter news application featuring country-based news, '
          'category filtering, location-aware local news, and multi-language support.',
        ),
        SizedBox(height: 16.h),
        const Text(
          'Powered by GNews API and Google ML Kit.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
