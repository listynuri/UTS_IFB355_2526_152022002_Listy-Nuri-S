// lib/screens/weather_home.dart
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

import 'soft_app_bar.dart';
import 'weather_detail.dart'; // aman dipakai karena detail TIDAK import home
import 'weather_types.dart'; // <-- enum, model, styles, iconPath di sini

/* =================== DUMMY DATA =================== */

final _cities = <CityWeather>[
  CityWeather(
    city: 'Jakarta',
    country: 'ID',
    temp: 31,
    time: DateTime.now(),
    cond: Condition.sunny,
    isNight: false,
    precip: 6,
    humidity: 58,
    windKmh: 12,
  ),
  CityWeather(
    city: 'Bandung',
    country: 'ID',
    temp: 23,
    time: DateTime.now().subtract(const Duration(hours: 2)),
    cond: Condition.cloudy,
    isNight: false,
    precip: 18,
    humidity: 72,
    windKmh: 9,
  ),
  CityWeather(
    city: 'Bali',
    country: 'ID',
    temp: 28,
    time: DateTime.now().add(const Duration(hours: 3)),
    cond: Condition.rain,
    isNight: true,
    precip: 64,
    humidity: 88,
    windKmh: 19,
  ),
];

/* =================== STYLE LOCAL =================== */

// gradient beda-beda tiap kartu kota (urut sesuai _cities)
const List<List<Color>> _cardGradients = [
  [Color.fromARGB(255, 230, 238, 253), Color.fromARGB(255, 187, 207, 255)],
  [Color.fromARGB(255, 240, 181, 200), Color.fromARGB(255, 197, 87, 123)],
  [Color.fromARGB(255, 239, 224, 250), Color.fromARGB(255, 101, 60, 126)],
];

Color _darken(Color c, [double amount = .16]) {
  final hsl = HSLColor.fromColor(c);
  final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return darker.toColor();
}

/* =================== HOME PAGE =================== */

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});
  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late final PageController _pc;
  int _idx = 0;

  @override
  void initState() {
    super.initState();
    _pc = PageController(viewportFraction: .82);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _toPrev() {
    if (_idx > 0) {
      _pc.previousPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _toNext() {
    if (_idx < _cities.length - 1) {
      _pc.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Background: putih → gradasi hangat
    const bg = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Color.fromARGB(255, 248, 251, 209),
        Color.fromARGB(255, 232, 209, 168),
        Color.fromARGB(255, 194, 174, 102),
      ],
      stops: [0.0, 0.42, 0.78, 1.0],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SoftTopBar(
        title: 'Weather',
        roundAll: true,
        horizontalMargin: 12,
        onBack: () => Navigator.maybePop(context),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: bg),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Header image
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/weather/ber.png',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          height: 170,
                          color: const Color(0xFFEFF6FF),
                          alignment: Alignment.center,
                          child: const Text('Header image'),
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Kartu + panah
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    PageView.builder(
                      controller: _pc,
                      itemCount: _cities.length,
                      onPageChanged: (i) => setState(() => _idx = i),
                      itemBuilder: (_, i) {
                        final c = _cities[i];
                        final s = condStyles[c.cond]!;
                        final grad = _cardGradients[i % _cardGradients.length];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          child: _CityGlassCard(
                            height:
                                380, // lebih pendek biar nggak mentok navbar
                            data: c,
                            accent: s.accent,
                            chip: s.chip,
                            bgColors: grad,
                            onView: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WeatherDetailPage(data: c),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    // Panah besar timbul
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ArrowButton(
                            icon: Icons.chevron_left_rounded,
                            onTap: _toPrev,
                            enabled: _idx > 0,
                          ),
                          _ArrowButton(
                            icon: Icons.chevron_right_rounded,
                            onTap: _toNext,
                            enabled: _idx < _cities.length - 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Jarak aman ke bottom navbar
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

/* =================== WIDGETS =================== */

class _CityGlassCard extends StatelessWidget {
  const _CityGlassCard({
    required this.height,
    required this.data,
    required this.accent,
    required this.chip,
    required this.bgColors,
    required this.onView,
  });

  final double height;
  final CityWeather data;
  final Color accent;
  final String chip;
  final List<Color> bgColors;
  final VoidCallback onView;

  String _fmt(DateTime t) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final d = days[t.weekday - 1];
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final am = t.hour >= 12 ? 'pm' : 'am';
    final m = t.minute.toString().padLeft(2, '0');
    final dd = t.day.toString().padLeft(2, '0');
    const mm = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '$d, $dd ${mm[t.month - 1]}  •  $h:$m $am';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // KARTU (glass + gradient)
        Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              // shadow bawah (3D)
              Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.18),
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    height: height,
                    padding: const EdgeInsets.fromLTRB(18, 60, 18, 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.78),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(.9),
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: bgColors,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Info kota + suhu + chip
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data.city}, ${data.country}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _fmt(data.time),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      _ChipSmall(
                                        text: 'Feels ~ ${data.temp + 1}°',
                                      ),
                                      _ChipSmall(text: chip),
                                      if (data.isNight)
                                        const _ChipSmall(text: 'Night'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${data.temp}°',
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 45),

                        // Tombol VIEW STATS
                        _RaisedPillButton(
                          label: 'VIEW STATS',
                          colors: [accent, _darken(accent, .16)],
                          onTap: onView,
                        ),

                        const SizedBox(height: 45),

                        // 3 STAT kecil
                        Row(
                          children: [
                            Expanded(
                              child: _InnerStatTile(
                                bg1: const Color(0xFFB71C1C),
                                bg2: const Color(0xFFD84343),
                                icon: Icons.water_drop,
                                label: 'Precip',
                                value: '${data.precip}%',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _InnerStatTile(
                                bg1: const Color(0xFF1E2A5A),
                                bg2: const Color(0xFF3D4B85),
                                icon: Icons.water,
                                label: 'Humi',
                                value: '${data.humidity}%',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _InnerStatTile(
                                bg1: const Color(0xFF3E2A78),
                                bg2: const Color(0xFF5B46A3),
                                icon: Icons.air_rounded,
                                label: 'Wind',
                                value:
                                    '${data.windKmh} km/h', // unit kecil di widget
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // IKON CUACA – BESAR & KELUAR DARI ATAS KARTU
        Positioned(
          top: -38,
          child: Image.asset(
            iconPath(
              data.cond,
              data.isNight,
            ), // <-- pakai dari weather_types.dart
            width: 190,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) =>
                    const Icon(Icons.cloud, size: 120, color: Colors.black26),
          ),
        ),
      ],
    );
  }
}

/* ===== panah besar dengan animasi tekan ===== */
class _ArrowButton extends StatefulWidget {
  const _ArrowButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1 : .35,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          child: Material(
            color: Colors.white.withOpacity(.85),
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: Colors.black26,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.enabled ? widget.onTap : null,
              onTapDown: (_) => setState(() => _scale = 0.92),
              onTapCancel: () => setState(() => _scale = 1.0),
              onTapUp: (_) => setState(() => _scale = 1.0),
              child: SizedBox(
                width: 54,
                height: 54,
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: const Color(0xFF2F3B36),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===== pill button rounded ===== */
class _RaisedPillButton extends StatefulWidget {
  const _RaisedPillButton({
    required this.label,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  State<_RaisedPillButton> createState() => _RaisedPillButtonState();
}

class _RaisedPillButtonState extends State<_RaisedPillButton> {
  double _scale = 1.0;
  bool _hover = false; // aktif di web/desktop, di mobile diabaikan

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: widget.colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // ❌ JANGAN: offset: const Offset(0, _hover ? 12 : 8),
    // ✅ Boleh dua cara di bawah:

    // CARA 1: hitung dulu variabelnya (paling simpel)
    final Offset dropOffset = _hover ? const Offset(0, 12) : const Offset(0, 8);
    final double blur = _hover ? 22 : 16;

    final List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withOpacity(.18),
        blurRadius: blur,
        offset: dropOffset,
      ),
    ];

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _scale = .96),
            onTapCancel: () => setState(() => _scale = 1.0),
            onTapUp: (_) => setState(() => _scale = 1.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: gradient,
                boxShadow: shadows, // pakai yang sudah dihitung
                border: Border.all(
                  color: Colors.white.withOpacity(.6),
                  width: 1,
                ),
              ),
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===== stat kecil di dalam kartu (unit km/h dikecilkan) ===== */
class _InnerStatTile extends StatelessWidget {
  const _InnerStatTile({
    required this.bg1,
    required this.bg2,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color bg1;
  final Color bg2;
  final IconData icon;
  final String label;
  final String value;

  InlineSpan _valueSpan(String v) {
    final kmh = RegExp(r'^\s*(\d+(?:\.\d+)?)\s*km/h\s*$', caseSensitive: false);
    final m = kmh.firstMatch(v);
    if (m != null) {
      final numPart = m.group(1)!;
      return TextSpan(
        children: [
          TextSpan(
            text: numPart,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const WidgetSpan(child: SizedBox(width: 3)),
          const TextSpan(
            text: 'km/h',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
    return const TextSpan(); // default akan diganti di bawah kalau bukan km/h
  }

  @override
  Widget build(BuildContext context) {
    final kmhRegex = RegExp(r'km/h', caseSensitive: false);
    final isKmh = kmhRegex.hasMatch(value);

    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bg1, bg2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.45)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.22),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
                if (isKmh)
                  Text.rich(
                    _valueSpan(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipSmall extends StatelessWidget {
  const _ChipSmall({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
