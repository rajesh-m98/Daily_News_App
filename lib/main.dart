import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Providers
import 'presentation/providers/language_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/news_provider.dart';

// Screens (for simple navigation)
import 'presentation/screens/splash_screen.dart';

// Navigation (for GoRouter)
import 'core/navigation/app_router.dart';

// Theme
import 'core/constants/app_theme.dart';
import 'core/constants/app_constants.dart';

/// Toggle between navigation methods
/// Set to true to use GoRouter (advanced routing)
/// Set to false to use simple Navigator (current implementation)
const bool useGoRouter = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Initialize ScreenUtil
          return ScreenUtilInit(
            designSize: const Size(375, 812), // iPhone X baseline
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              // Use GoRouter or simple Navigator based on flag
              if (useGoRouter) {
                return MaterialApp.router(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,

                  // Theme
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeProvider.themeMode,

                  // GoRouter configuration
                  routerConfig: AppRouter.createRouter(),
                );
              } else {
                return MaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,

                  // Theme
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeProvider.themeMode,

                  // Simple navigation
                  home: const SplashScreen(),
                );
              }
            },
          );
        },
      ),
    );
  }
}
