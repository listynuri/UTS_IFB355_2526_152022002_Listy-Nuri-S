import 'package:flutter/material.dart';

/* ==== Enum & Model ==== */
enum Condition { sunny, cloudy, rain, storm }

class CityWeather {
  final String city;
  final String country;
  final int temp; // °C
  final DateTime time;
  final Condition cond;
  final bool isNight;

  // STAT
  final int precip; // %
  final int humidity; // %
  final int windKmh; // km/h

  CityWeather({
    required this.city,
    required this.country,
    required this.temp,
    required this.time,
    required this.cond,
    required this.isNight,
    required this.precip,
    required this.humidity,
    required this.windKmh,
  });
}

/* ==== Styles per kondisi ==== */
class CondStyle {
  final Color accent;
  final String chip;
  const CondStyle(this.accent, this.chip);
}

final Map<Condition, CondStyle> condStyles = {
  Condition.sunny: CondStyle(const Color(0xFF4A4C70), 'Sunny'),
  Condition.cloudy: CondStyle(const Color(0xFF48183F), 'Cloudy'),
  Condition.rain: CondStyle(const Color(0xFF094474), 'Rain'),
  Condition.storm: CondStyle(const Color(0xFF7F6BFF), 'Storm'),
};

/* ==== Asset helper ==== */
// lib/screens/weather_types.dart (cuplikan)

String iconPath(Condition c, bool night) {
  switch (c) {
    case Condition.sunny:
      return night ? 'assets/weather/mthri.png' : 'assets/weather/mthri.png';
    case Condition.cloudy:
      return night ? 'assets/weather/gerimis.png' : 'assets/weather/awan.png';
    case Condition.rain:
      // pakai gerimis siang, angins malam (atau ganti ke hujan.png kalau mau)
      return night ? 'assets/weather/angins.png' : 'assets/weather/gerimis.png';
    case Condition.storm:
      return night ? 'assets/weather/malam.png' : 'assets/weather/petir.png';
  }
}

/* ==== Label helper ==== */
String condLabel(Condition c) {
  switch (c) {
    case Condition.sunny:
      return 'Sunny';
    case Condition.cloudy:
      return 'Cloudy';
    case Condition.rain:
      return 'Rain';
    case Condition.storm:
      return 'Storm';
  }
}
