import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kagi_news/ui/screens/kagi_news_page.dart';
import 'package:kagi_news/ui/screens/splash_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const home = '/';
  static const clusterDetails = 'cluster/:fileName/:clusterIndex';

  AppRoutes._();
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'news',
      builder: (_, _) => KagiNewsPage(),
    ),
  ],
  errorBuilder:
      (_, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.uri.path}')),
      ),
);
