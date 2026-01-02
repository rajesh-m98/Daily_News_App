import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/language_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/translation_service.dart';
import 'home_screen.dart';

/// Language Selection Screen
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;
  bool _isDownloading = false;
  final TranslationService _translationService = TranslationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Header
              Text(
                'Choose Your Language',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your preferred language for news',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              // Language List
              Expanded(
                child: ListView.builder(
                  itemCount: AppConstants.supportedLanguages.length,
                  itemBuilder: (context, index) {
                    final entry = AppConstants.supportedLanguages.entries
                        .elementAt(index);
                    final code = entry.key;
                    final name = entry.value;

                    return _buildLanguageCard(code, name);
                  },
                ),
              ),

              // Continue Button
              if (_selectedLanguage != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isDownloading ? null : _onContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isDownloading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String code, String name) {
    final isSelected = _selectedLanguage == code;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: () => setState(() => _selectedLanguage = code),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Radio Button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),

              // Language Name
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),

              // Language Icon
              Icon(
                Icons.language,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    if (_selectedLanguage == null) return;

    setState(() => _isDownloading = true);

    try {
      // Set language in provider
      await context.read<LanguageProvider>().setLanguage(_selectedLanguage!);

      // Download translation model if needed (non-English)
      if (_selectedLanguage != 'en') {
        await _translationService.downloadLanguageModel(_selectedLanguage!);
      }

      // Mark first launch as complete
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsFirstLaunch, false);

      if (!mounted) return;

      // Navigate to home
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }
}
