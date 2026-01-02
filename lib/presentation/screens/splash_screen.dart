import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/news_provider.dart';
import '../../core/constants/app_constants.dart';
import 'language_selection_screen.dart';
import 'home_screen.dart';

/// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Initialize app
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize providers
    await Future.wait([
      context.read<LanguageProvider>().init(),
      context.read<ThemeProvider>().init(),
      context.read<NewsProvider>().init(),
    ]);

    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 2));

    // Check if first launch
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(AppConstants.keyIsFirstLaunch) ?? true;

    if (!mounted) return;

    if (isFirstLaunch) {
      // Navigate to language selection
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    } else {
      // Navigate to home
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20.r,
                          offset: Offset(0, 10.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.newspaper,
                      size: 80.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // App Name
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Tagline
                  Text(
                    'Stay Informed, Stay Ahead',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 48.h),

                  // Loading Indicator
                  SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      strokeWidth: 3.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
