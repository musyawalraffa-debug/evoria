import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/sanctuary_providers.dart';
import 'core/router/app_router.dart';
import 'core/services/memory_service.dart';
import 'core/theme/evoria_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final memoryService = MemoryService(prefs);
  await memoryService.getMemories(); // triggers seed if needed

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const EvoriaApp(),
    ),
  );
}

class EvoriaApp extends ConsumerWidget {
  const EvoriaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'EVORIA',
      debugShowCheckedModeBanner: false,
      theme: EvoriaTheme.light(),
      darkTheme: EvoriaTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'), // Bahasa Indonesia
        Locale('en', 'US'),
      ],
      locale: const Locale('id', 'ID'),
    );
  }
}
