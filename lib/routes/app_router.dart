import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kagi_news/ui/kagi_news_page.dart';

class AppRoutes {
  static const home = '/';
  static const details = '/home';

  AppRoutes._();
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'news',
      builder: (context, state) => KagiNewsPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri.path}'),
    ),
  ),
);
