import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'dart:ui' show ImageFilter;

import '../theme.dart';
import 'biodata_page.dart';
import 'contacts_page.dart';
import 'calculator_page.dart';
import 'weather_home.dart';
import 'news_page.dart';

Color catColor(String cat) {
  switch (cat.toLowerCase()) {
    case 'campus':
      return const Color(0xFFFFE0EB); // pink muda
    case 'health':
      return const Color(0xFFE6F0FF); // biru muda
    case 'tech':
      return const Color(0xFFE8FFF2); // hijau muda
    case 'world':
      return const Color(0xFFFFF4E0); // krem muda
    case 'uplifting':
      return const Color(0xFFF3E6FF); // ungu muda
    default:
      return const Color(0xFFF1F2F6); // abu soft
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _index = 0;

  final _searchCtrl = TextEditingController();
  bool _onlyFavorites = false;

  final pages = [
    const BiodataPage(),
    const ContactsPage(),
    CalculatorPage(),
    const WeatherHomePage(), // <-- halaman cuaca (home/list kota)
    const NewsPage(),
  ];

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.creamy,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setModal) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Filter pencarian',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Hanya favorit'),
                        value: _onlyFavorites,
                        onChanged: (v) => setModal(() => _onlyFavorites = v),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(ctx);
                        },
                        child: const Text('Terapkan'),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    const headerH = 280.0;
    const headerExtra = 40.0;
    final isHome = _index == 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          isHome
              ? const SystemUiOverlayStyle(
                statusBarColor: Color(0xFFFFFFFF),
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              )
              : const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
      child: Scaffold(
        backgroundColor: isHome ? const Color(0xFFFFFFFF) : Colors.white,
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body:
            isHome
                ? Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      height: headerH + headerExtra,
                      child: Image.asset(
                        'assets/images/header.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 10, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    212,
                                    212,
                                    212,
                                  ).withOpacity(0.60),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.95),
                                    width: 0.6,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Image.asset(
                                        'assets/images/profile.png',
                                        width: 46,
                                        height: 46,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Container(
                                              width: 46,
                                              height: 46,
                                              color: const Color(0xFFEDEDED),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.person,
                                                size: 24,
                                                color: Colors.black54,
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Hello, Listy 👋',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Welcome back',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge?.copyWith(
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Image.asset(
                                      'assets/images/gambar.png',
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Container(
                                            width: 48,
                                            height: 48,
                                            color: const Color(0xFFEDEDED),
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.image,
                                              size: 22,
                                              color: Colors.black45,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // BODY putih rounded (scroll)
                    Positioned.fill(
                      top: (headerH + headerExtra) - 28,
                      child: _HomeBodyBox(
                        searchCtrl: _searchCtrl,
                        onFilterTap: _openFilters,
                        onlyFavorites: _onlyFavorites,
                        onMenuTap: (i) => _goTo(i),
                        onViewAllNews:
                            () => Navigator.pushNamed(context, '/news'),
                      ),
                    ),
                  ],
                )
                : Container(
                  color: Colors.white,
                  child: IndexedStack(index: _index - 1, children: pages),
                ),

        // ========= Bottom Nav =========
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: GradientNavBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
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
      ),
    );
  }
}

class _HomeBodyBox extends StatelessWidget {
  const _HomeBodyBox({
    required this.searchCtrl,
    required this.onFilterTap,
    required this.onlyFavorites,
    required this.onMenuTap,
    required this.onViewAllNews,
  });

  final TextEditingController searchCtrl;
  final VoidCallback onFilterTap;
  final bool onlyFavorites;
  final void Function(int idx) onMenuTap;
  final VoidCallback onViewAllNews;

  @override
  Widget build(BuildContext context) {
    // Quick menus: (label, assetPath, pageIndex, withCircle)
    final menus = [
      ('Profile', 'assets/images/ic_profile.png', 1, false),
      ('Contact', 'assets/images/ic_contacts.png', 2, true),
      ('Calc', 'assets/images/ic_calc.png', 3, true),
      ('Weather', 'assets/images/ic_weather.png', 4, true),
      ('News', 'assets/images/quick_news.png', 5, true),
    ];

    const pastel = <Color>[
      Color(0xFFF6F6F9),
      Color(0xFFFFF1F4),
      Color(0xFFEFF6FF),
      Color(0xFFEFFCF3),
      Color(0xFFFFF8E7),
      Color(0xFFF4ECFF),
    ];

    const quickBg = Color(0xFFFFF1F4);
    const weatherBg = Color(0xFFEFF6FF);

    final bottomPad = 28 + MediaQuery.of(context).padding.bottom + 72;

    // Helper: kartu kecil dengan tinggi fix (TIDAK menggunakan Expanded)
    Widget pastelCardBox({required Color bg, required Widget child}) {
      return SizedBox(
        height: 126,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8E8EE)),
          ),
          child: child,
        ),
      );
    }

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: Column(
        children: [
          // ======= SEARCH (fixed) =======
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.creamy,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,
                            cursorColor: Colors.black54,
                            decoration: const InputDecoration(
                              hintText: 'Search your task ...',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: onFilterTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Icon(Icons.tune_rounded),
                  ),
                ),
              ],
            ),
          ),

          // ======= SCROLL CONTENT =======
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duo cards: Quick Contact & Weather
                  LayoutBuilder(
                    builder: (ctx, c) {
                      final w = c.maxWidth;
                      final isNarrow = w < 360;

                      final quickOne = pastelCardBox(
                        bg: quickBg,
                        child: const _QuickContactMini(),
                      );
                      final weatherMini = pastelCardBox(
                        bg: weatherBg,
                        child: const _WeatherNowMini(),
                      );

                      if (isNarrow) {
                        // JANGAN pakai Expanded di Column (dalam scroll)
                        return Column(
                          children: [
                            quickOne,
                            const SizedBox(height: 12),
                            weatherMini,
                          ],
                        );
                      } else {
                        // Kalau Row, baru pakai Expanded DI SINI (di luar helper)
                        return Row(
                          children: [
                            Expanded(child: quickOne),
                            const SizedBox(width: 12),
                            Expanded(child: weatherMini),
                          ],
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Quick menus',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),

                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: searchCtrl,
                    builder: (_, val, __) {
                      final q = val.text.trim().toLowerCase();
                      final list =
                          q.isEmpty
                              ? menus
                              : menus
                                  .where((m) => m.$1.toLowerCase().contains(q))
                                  .toList();

                      if (list.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Tidak ada menu yang cocok.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(width: 12),
                          itemBuilder: (ctx, i) {
                            final m = list[i];
                            final circleColor = pastel[i % pastel.length];
                            return _MenuImage(
                              label: m.$1,
                              assetPath: m.$2,
                              onTap: () => onMenuTap(m.$3),
                              withCircle: m.$4,
                              circleColor: circleColor,
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Berita',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onViewAllNews,
                        child: const Text('View all'),
                      ),
                    ],
                  ),

                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: searchCtrl,
                    builder: (_, val, __) {
                      final q = val.text;
                      return _HomeNewsPreview(
                        kPreviewHeight: 252,
                        query: q,
                        onlyFavorites: onlyFavorites,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  const _MenuImage({
    required this.label,
    required this.assetPath,
    required this.onTap,
    this.withCircle = true,
    this.circleColor = const Color(0xFFF6F6F9),
  });

  final String label;
  final String assetPath;
  final VoidCallback onTap;
  final bool withCircle;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    final image =
        withCircle
            ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assetPath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 18),
                    ),
              ),
            )
            : ClipOval(
              child: Image.asset(
                assetPath,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, size: 24),
                    ),
              ),
            );

    return Column(
      children: [
        Material(
          color: withCircle ? circleColor : Colors.transparent,
          shape:
              withCircle
                  ? const CircleBorder()
                  : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(width: 64, height: 64, child: Center(child: image)),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _QuickContactMini extends StatelessWidget {
  const _QuickContactMini();

  @override
  Widget build(BuildContext context) {
    const name = 'Rara';
    const phone = '0812-3456-7890';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 76, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Contact',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/avatar_rara.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 44,
                              height: 44,
                              color: const Color(0xFFEDEDED),
                              alignment: Alignment.center,
                              child: const Icon(Icons.person, size: 22),
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            phone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Row(
              children: [
                _roundSmallIconButton(icon: Icons.message, onTap: () {}),
                const SizedBox(width: 6),
                _roundSmallIconButton(icon: Icons.call, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundSmallIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Center(child: Icon(icon, size: 16)),
        ),
      ),
    );
  }
}

class _WeatherNowMini extends StatelessWidget {
  const _WeatherNowMini();

  @override
  Widget build(BuildContext context) {
    const temp = '31°';
    const loc = 'Jakarta';
    const desc = 'Cerah berawan';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'Cuaca saat ini ',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(width: 10),
                Text(
                  temp,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.wb_sunny_rounded,
                  size: 40,
                  color: Color(0xFFFFB300),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        desc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.7),
                borderRadius: BorderRadius.circular(99),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.55,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C7BFF),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================== HOME NEWS PREVIEW (pakai JSON) ==================
class _HomeNewsPreview extends StatelessWidget {
  const _HomeNewsPreview({
    this.kPreviewHeight = 252,
    this.query = '',
    this.onlyFavorites = false,
  });

  final double kPreviewHeight;
  final String query;
  final bool onlyFavorites;

  Future<List<_PreviewArticle>> _load() async {
    final raw = await rootBundle.loadString('assets/news/news.json');
    final list =
        (jsonDecode(raw) as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

    // Urutkan: populer dulu
    final sorted = List<Map<String, dynamic>>.from(list)..sort(
      (a, b) => (b['isPopular'] == true ? 1 : 0).compareTo(
        a['isPopular'] == true ? 1 : 0,
      ),
    );

    // Filter favorit jika dipilih
    var filtered =
        onlyFavorites
            ? sorted.where((m) => (m['isPopular'] as bool?) == true).toList()
            : sorted;

    // Filter query ke judul/kategori/sumber
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered =
          filtered.where((m) {
            final title = (m['title'] ?? '').toString().toLowerCase();
            final cat = (m['category'] ?? '').toString().toLowerCase();
            final src = (m['source'] ?? '').toString().toLowerCase();
            return title.contains(q) || cat.contains(q) || src.contains(q);
          }).toList();
    }

    // Ambil maksimal 6 item
    final pick = filtered.take(6).toList();

    return pick
        .map(
          (m) => _PreviewArticle(
            title: m['title'] as String,
            image: m['image'] as String,
            category: m['category'] as String,
            date: DateTime.parse(m['date'] as String),
            source: m['source'] as String,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_PreviewArticle>>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return SizedBox(
            height: kPreviewHeight,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError || snap.data == null) {
          return SizedBox(
            height: kPreviewHeight,
            child: const Center(child: Text('Gagal memuat berita')),
          );
        }

        final news = snap.data!;
        if (news.isEmpty) {
          return SizedBox(
            height: kPreviewHeight,
            child: const Center(child: Text('Tidak ada berita yang cocok.')),
          );
        }

        return SizedBox(
          height: kPreviewHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 6),
            itemCount: news.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final n = news[i];
              return _NewsCardHorizontal(
                title: n.title,
                img: n.image,
                category: n.category,
                date: n.date,
                source: n.source,
              );
            },
          ),
        );
      },
    );
  }
}

class _PreviewArticle {
  final String title, image, category, source;
  final DateTime date;
  _PreviewArticle({
    required this.title,
    required this.image,
    required this.category,
    required this.date,
    required this.source,
  });
}

class _NewsCardHorizontal extends StatelessWidget {
  const _NewsCardHorizontal({
    required this.title,
    required this.img,
    required this.category,
    required this.date,
    required this.source,
  });

  final String title;
  final String img;
  final String category;
  final DateTime date;
  final String source;

  String _fmtDate(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return "${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]}, ${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                img,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      color: const Color(0xFFF3F3F3),
                      alignment: Alignment.center,
                      child: const Text('img'),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Chip(
                    label: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    backgroundColor: catColor(category),
                    shape: const StadiumBorder(),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$source  •  ${_fmtDate(date)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= WIDGET: GRADIENT NAV BAR =======================
class GradientNavBar extends StatelessWidget {
  const GradientNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.gradient,
    required this.icons,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Gradient gradient;
  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF93B5A3).withOpacity(0.32),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(icons.length, (i) {
            final selected = i == currentIndex;
            return _GradientNavItem(
              icon: icons[i],
              selected: selected,
              onTap: () => onTap(i),
            );
          }),
        ),
      ),
    );
  }
}

class _GradientNavItem extends StatelessWidget {
  const _GradientNavItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: selected ? 52 : 44,
            height: selected ? 52 : 44,
            decoration: BoxDecoration(
              gradient:
                  selected
                      ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8FD3A8), Color(0xFF7FBF99)],
                      )
                      : null,
              color: selected ? null : Colors.white.withOpacity(.14),
              borderRadius: BorderRadius.circular(16),
              boxShadow:
                  selected
                      ? const [
                        BoxShadow(
                          color: Color(0x668FD3A8),
                          blurRadius: 16,
                          spreadRadius: 1,
                          offset: Offset(0, 6),
                        ),
                      ]
                      : const [],
            ),
            child: Icon(
              icon,
              size: 24,
              color: selected ? Colors.white : const Color(0xFF2F3B36),
            ),
          ),
        ),
      ),
    );
  }
}
