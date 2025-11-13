// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:uts_listyapp/screens/dashboard.dart';
import 'package:uts_listyapp/screens/contacts_page.dart';
import 'package:uts_listyapp/screens/biodata_page.dart';
import 'package:uts_listyapp/screens/news_page.dart';
import 'package:uts_listyapp/screens/weather_detail.dart';

// ⬇️ CityWeather sekarang dari weather_types.dart, bukan dari weather_home.dart
import 'package:uts_listyapp/screens/weather_types.dart' show CityWeather;

import 'theme.dart';
import 'splash_animated.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge + status bar/nav bar styling
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MobAppUTS());
}

class MobAppUTS extends StatelessWidget {
  const MobAppUTS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listy Verse App UTS',
      debugShowCheckedModeBanner: false,
      theme: buildTheme().copyWith(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),

      // Splash sebagai entry
      home: const SplashAnimatedPage(),

      // Static routes
      routes: {
        '/dashboard': (_) => const Dashboard(),
        '/contacts': (_) => const ContactsPage(),
        '/biodata': (_) => const BiodataPage(),
        '/news': (_) => NewsPage(),
      },

      // Route dinamis untuk detail cuaca (pakai arguments)
      onGenerateRoute: (settings) {
        if (settings.name == '/weather/detail') {
          final args = settings.arguments;
          if (args is CityWeather) {
            return MaterialPageRoute(
              builder: (_) => WeatherDetailPage(data: args),
              settings: settings,
            );
          }
          // Fallback kalau argument salah/NULL – biar nggak crash
          return MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text('Data cuaca tidak tersedia')),
                ),
            settings: settings,
          );
        }
        return null; // biar routes[] yang handle selain itu
      },
    );
  }
}
