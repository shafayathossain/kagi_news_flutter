import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kagi_news/di/injector.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:kagi_news/routes/app_router.dart';
import 'package:kagi_news/services/background_fetch_service.dart';
import 'package:kagi_news/ui/common/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Injector.setup();

  await BackgroundFetchService.initialize();

  LocaleSettings.useDeviceLocale();
  runApp(TranslationProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: Translations.of(context).app.title,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorScheme: AppTheme.lightScheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: AppTheme.darkScheme(),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
