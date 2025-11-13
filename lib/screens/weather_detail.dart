// lib/screens/weather_detail.dart
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:uts_listyapp/screens/dashboard.dart';

import 'soft_app_bar.dart';
import 'weather_types.dart'
    show CityWeather, Condition, condStyles, iconPath, condLabel;

class WeatherDetailPage extends StatelessWidget {
  const WeatherDetailPage({super.key, required this.data});
  final CityWeather data;

  @override
  Widget build(BuildContext context) {
    final style = condStyles[data.cond]!;
    final night = _isNight();

    // Background lembut
    const bg = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Color(0xFFEFF6FF),
        Color(0xFFE8F7EE),
        Colors.white,
      ],
      stops: [0.0, 0.42, 0.78, 1.0],
    );

    final hourly = _dummyHourly(data);
    final days = _dummyDaily(data);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SoftTopBar(
        title: '${data.city}, ${data.country}',
        roundAll: true,
        horizontalMargin: 12,
        onBack: () => Navigator.maybePop(context),
      ),

      // ========= BODY: 100% scrollable, no overflow =========
      body: Container(
        decoration: const BoxDecoration(gradient: bg),
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            slivers: [
              // ===== HERO CARD (glass + 3D + PNG lebih besar) =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _Glass3D(
                    radius: 24,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ikon PNG + glow (aman dari overflow)
                        Container(
                          width: 100,
                          height: 100,
                          clipBehavior:
                              Clip.antiAlias, // penting: potong sisa gambar
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                style.accent.withOpacity(.35),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain, // scale down ke 100x100
                            child: Image.asset(
                              iconPath(data.cond, night),
                              // HAPUS width/height 500 agar tidak memaksa
                              errorBuilder:
                                  (_, __, ___) => const Icon(
                                    Icons.cloud,
                                    size: 80,
                                    color: Colors.black26,
                                  ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _Chip(text: 'Feels like ${data.temp + 1}°'),
                                  _Chip(text: condLabel(data.cond)),
                                  if (night) const _Chip(text: 'Night'),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Selalu 1 baris, tapi mengecil otomatis bila width-nya sempit
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: const [
                                    _Metric(
                                      icon: Icons.water_drop,
                                      label: '28%',
                                      compact: true,
                                    ),
                                    SizedBox(width: 10),
                                    _Metric(
                                      icon: Icons.air_rounded,
                                      label: '8 km/h',
                                      compact: true,
                                    ),
                                    SizedBox(width: 10),
                                    _Metric(
                                      icon: Icons.nightlight_round,
                                      label: '64%',
                                      compact: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Suhu besar tetap aman
                        Text(
                          '${data.temp}°',
                          style: const TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===== TODAY + list horizontal scrollable =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        'Next 7 days',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 72 + 12 + MediaQuery.of(context).padding.bottom + 8,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: hourly.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final h = hourly[i];
                      final highlight = i == 1; // contoh current
                      return _HourPill(
                        time: h.time,
                        temp: h.temp,
                        cond: h.cond,
                        night: night,
                        highlight: highlight,
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ===== BOX BAWAH: Next 7 days (warna pastel serasi) =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Glass3D(
                    radius: 20,
                    padding: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        // pastel lembut
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _pastelByCond(data.cond),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          ...List.generate(days.length, (i) {
                            final d = days[i];
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                12,
                                i == 0 ? 0 : 8,
                                12,
                                8,
                              ),
                              child: _DayRow(
                                label: d.label,
                                hi: d.hi,
                                lo: d.lo,
                                cond: d.cond,
                                night: night,
                              ),
                            );
                          }),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // bottom spacer supaya tidak ketutup navbar
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 16,
                ),
              ),
            ],
          ),
        ),
      ),

      // di build() -> return Scaffold(
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: GradientNavBar(
          currentIndex: 4, // Weather tab aktif (sesuai Dashboard)
          onTap: (i) {
            // Sesuaikan dengan skema routing milikmu:
            switch (i) {
              case 0:
                Navigator.pushNamed(context, '/');
                break; // Home
              case 1:
                Navigator.pushNamed(context, '/profile');
                break; // Biodata
              case 2:
                Navigator.pushNamed(context, '/contacts');
                break; // Contacts
              case 3:
                Navigator.pushNamed(context, '/calculator');
                break; // Calculator
              case 4: /* sedang di Weather */
                break;
              case 5:
                Navigator.pushNamed(context, '/news');
                break; // News
            }
          },
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFCDE9D7), Color(0xFFB9D9C6), Color(0xFFA7CDB7)],
          ),
          icons: const [
            Icons.home,
            Icons.person,
            Icons.contacts,
            Icons.calculate,
            Icons.wb_sunny,
            Icons.article,
          ],
        ),
      ),
    );
  }

  static bool _isNight() {
    final h = DateTime.now().hour;
    return h >= 18 || h < 6;
  }

  // Palet pastel berdasarkan kondisi (buat kotak bawah)
  static List<Color> _pastelByCond(Condition c) {
    switch (c) {
      case Condition.sunny:
        return const [Color.fromARGB(255, 252, 209, 160), Color(0xFFFFF9EC)];
      case Condition.cloudy:
        return const [
          Color.fromARGB(255, 210, 218, 239),
          Color.fromARGB(255, 141, 152, 195),
        ];
      case Condition.rain:
        return const [
          Color.fromARGB(255, 192, 217, 222),
          Color.fromARGB(255, 159, 166, 200),
        ];
      case Condition.storm:
        return const [Color(0xFFEFE6FF), Color.fromARGB(255, 103, 85, 128)];
    }
  }
}

/* --------- Glass card with 3D drop shadow --------- */
class _Glass3D extends StatelessWidget {
  const _Glass3D({
    required this.child,
    required this.radius,
    required this.padding,
  });
  final Widget child;
  final double radius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius + 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.16),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.72),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: Colors.white.withOpacity(.90),
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

/* --------- TODAY pill (scroll kanan) --------- */
class _HourPill extends StatelessWidget {
  const _HourPill({
    required this.time,
    required this.temp,
    required this.cond,
    required this.night,
    this.highlight = false,
  });

  final String time;
  final int temp;
  final Condition cond;
  final bool night;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = _hourPastel(cond);
    return Container(
      width: 92,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E6EC)),
        boxShadow:
            highlight
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(.12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
                : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800, height: 1),
          ),
          const SizedBox(height: 4),

          // Biarkan image mengambil ruang sisa dan mengecil bila perlu
          Expanded(
            child: Center(
              child: Image.asset(
                iconPath(cond, night),
                fit: BoxFit.contain, // penting: jangan pakai width/height fix
              ),
            ),
          ),

          const SizedBox(height: 4),
          Text(
            '$temp°',
            style: const TextStyle(fontWeight: FontWeight.w900, height: 1),
          ),
        ],
      ),
    );
  }

  List<Color> _hourPastel(Condition c) {
    switch (c) {
      case Condition.sunny:
        return const [Color(0xFFFFF2CC), Color(0xFFFFFAE6)];
      case Condition.cloudy:
        return const [Color(0xFFEAF0FF), Color(0xFFF7FAFF)];
      case Condition.rain:
        return const [Color(0xFFDFF7FF), Color(0xFFF3FCFF)];
      case Condition.storm:
        return const [Color(0xFFEFE6FF), Color(0xFFF8F3FF)];
    }
  }
}

/* --------- Next 7 days row (ikon lebih besar) --------- */
class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.label,
    required this.hi,
    required this.lo,
    required this.cond,
    required this.night,
  });

  final String label;
  final int hi, lo;
  final Condition cond;
  final bool night;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E6EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath(cond, night),
            width: 70, // <-- lebih besar
            height: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '$hi°',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text('/ $lo°', style: const TextStyle(color: Colors.black54)),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            child: Text(
              condLabel(cond),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Small UI bits ---------- */
class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padH = compact ? 8.0 : 10.0;
    final padV = compact ? 4.0 : 6.0;
    final iconSize = compact ? 16.0 : 18.0;
    final gap = compact ? 4.0 : 6.0;
    final fontSize = compact ? 12.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.32),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: Colors.black87),
          SizedBox(width: gap),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: fontSize,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Dummy data ---------- */
class _Hour {
  final String time;
  final int temp;
  final Condition cond;
  _Hour(this.time, this.temp, this.cond);
}

class _Day {
  final String label;
  final int hi, lo;
  final Condition cond;
  _Day(this.label, this.hi, this.lo, this.cond);
}

List<_Hour> _dummyHourly(CityWeather d) {
  final base = d.temp;
  return [
    _Hour('10:00', base - 1, Condition.cloudy),
    _Hour('12:00', base, d.cond),
    _Hour('14:00', base + 1, Condition.sunny),
    _Hour('16:00', base, Condition.cloudy),
    _Hour('18:00', base - 2, Condition.rain),
    _Hour('20:00', base - 3, d.cond),
  ];
}

List<_Day> _dummyDaily(CityWeather d) {
  final now = DateTime.now();
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
  String label(DateTime t) =>
      '${t.day.toString().padLeft(2, '0')} ${mm[t.month - 1]}, '
      '${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][t.weekday - 1]}';

  return List.generate(7, (i) {
    final day = now.add(Duration(days: i + 1));
    final hi = d.temp + (i % 3) - 1;
    final lo = hi - 6 - (i % 2);
    final cond =
        [Condition.sunny, Condition.cloudy, Condition.rain, Condition.storm][i %
            4];
    return _Day(label(day), hi, lo, cond);
  });
}
