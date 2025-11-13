// lib/screens/news_page.dart
import 'dart:convert';
import 'dart:ui' show ImageFilter; // untuk efek blur
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../theme.dart'; // untuk AppColors (opsional, bisa ganti manual)

// >>> Atur tinggi header featured di sini:
const double kHeaderHeight = 320.0; // 300–360 enak. Silakan ubah sesuka hati.

/* ================== PAGE ================== */

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<_NewsData> _future;

  // state filter
  String _selectedCategory = 'All';
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _order = 'ASC'; // ASC / DESC

  @override
  void initState() {
    super.initState();
    _future = _loadNews();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<_NewsData> _loadNews() async {
    final raw = await rootBundle.loadString('assets/news/news.json');
    final list =
        (jsonDecode(raw) as List)
            .map((e) => NewsArticle.fromJson(Map<String, dynamic>.from(e)))
            .toList();

    final cats = <String>{'All'}..addAll(list.map((e) => e.category));
    final featured = list.firstWhere(
      (e) => e.isFeatured,
      orElse: () => list.first,
    );
    final popular = list.where((e) => e.isPopular).toList();

    return _NewsData(
      all: list,
      categories: cats.toList(),
      featured: featured,
      popular: popular,
    );
  }

  List<NewsArticle> _apply(List<NewsArticle> all) {
    var r =
        _selectedCategory == 'All'
            ? List<NewsArticle>.from(all)
            : all.where((e) => e.category == _selectedCategory).toList();

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      r =
          r
              .where(
                (e) =>
                    e.title.toLowerCase().contains(q) ||
                    e.summary.toLowerCase().contains(q) ||
                    e.source.toLowerCase().contains(q),
              )
              .toList();
    }

    r.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    if (_order == 'DESC') r = r.reversed.toList();
    return r;
  }

  void _toggleSort() =>
      setState(() => _order = _order == 'ASC' ? 'DESC' : 'ASC');

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);

    return FutureBuilder<_NewsData>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            body: SafeArea(child: Center(child: Text('Error: ${snap.error}'))),
          );
        }

        final data = snap.data!;
        final filtered = _apply(data.all);

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // ======= KONTEN UTAMA =======
              SafeArea(
                child: Column(
                  children: [
                    // HEADER FEATURED (tinggi bisa diatur)
                    _FeaturedHeader(
                      article: data.featured,
                      height: kHeaderHeight,
                    ),

                    // KATEGORI CHIPS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                      child: SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final cat = data.categories[i];
                            final selected = cat == _selectedCategory;
                            return ChoiceChip(
                              selected: selected,
                              label: Text(cat),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: selected ? Colors.white : Colors.black87,
                              ),
                              selectedColor: const Color(0xFFBA679D),
                              backgroundColor: const Color(0xFFF1F2F6),
                              onSelected:
                                  (_) =>
                                      setState(() => _selectedCategory = cat),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // SEARCH + SORT
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (v) => setState(() => _query = v),
                              decoration: InputDecoration(
                                hintText: 'Search News…',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon:
                                    _query.isEmpty
                                        ? null
                                        : IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            _searchCtrl.clear();
                                            setState(() => _query = '');
                                          },
                                        ),
                                filled: true,
                                fillColor: const Color.fromARGB(
                                  255,
                                  237,
                                  240,
                                  218,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE6E6EC),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE6E6EC),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD0D0D7),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              textInputAction: TextInputAction.search,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Tooltip(
                            message:
                                _order == 'ASC' ? 'Urut A → Z' : 'Urut Z → A',
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                onTap: _toggleSort,
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFE6E6EC),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.sort_by_alpha_rounded,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // LIST BERITA & POPULAR (scroll)
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          // list artikel
                          ...List.generate(filtered.length, (i) {
                            final n = filtered[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ClipRRect(
                                borderRadius: radius,
                                child: Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // thumbnail kiri
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(22),
                                            bottomLeft: Radius.circular(22),
                                          ),
                                          child: Image.asset(
                                            n.image,
                                            width: 110,
                                            height: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) => Container(
                                                  width: 110,
                                                  height: 90,
                                                  color: const Color(
                                                    0xFFF3F3F3,
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Text('img'),
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // teks
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 4,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  n.title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  n.summary,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "${n.source}  •  ${_fmtDate(n.date)}",
                                                  style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 8),
                          Text(
                            'Popular Articles',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),

                          SizedBox(
                            height: 148,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(right: 6),
                              itemCount: data.popular.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 12),
                              itemBuilder: (_, i) {
                                final n = data.popular[i];
                                return SizedBox(
                                  width: 270,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(16),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  bottomLeft: Radius.circular(
                                                    16,
                                                  ),
                                                ),
                                            child: Image.asset(
                                              n.image,
                                              width: 90,
                                              height: 148,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) => Container(
                                                    width: 90,
                                                    height: 148,
                                                    color: const Color(
                                                      0xFFF3F3F3,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: const Text('img'),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10,
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _TagChip(text: n.source),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    n.title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    _fmtDate(n.date),
                                                    style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ======= GLASS / BLUR TOP BAR OVERLAY =======
              _GlassTopBar(
                title: 'News',
                onBack: () {
                  final nav = Navigator.of(context);
                  if (nav.canPop()) {
                    nav.pop();
                  } else {
                    // kalau halaman ini root, langsung ke dashboard
                    nav.pushNamedAndRemoveUntil('/dashboard', (route) => false);
                    // kalau kamu pakai Navigator bertingkat (shell/tab), pakai rootNavigator:
                    // Navigator.of(context, rootNavigator: true)
                    //   .pushNamedAndRemoveUntil('/dashboard', (route) => false);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime d) {
    const months = [
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
    return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]}, ${d.year}";
  }
}

/* ================== SUBWIDGET & MODELS ================== */

class _GlassTopBar extends StatelessWidget {
  // sengaja TIDAK const untuk menghindari isu hot-reload const<->non-const
  _GlassTopBar({required this.title, this.onBack});
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        // kiri-kanan pendek biar sejajar sama konten bawah
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.60),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(.75),
                  width: .8,
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
                children: [
                  Material(
                    color: AppColors.oliveMist,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onBack ?? () => Navigator.maybePop(context),
                      splashColor: Colors.white.withOpacity(.25),
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedHeader extends StatelessWidget {
  const _FeaturedHeader({
    required this.article,
    this.height = 230, // default lama, bisa dioverride
  });

  final NewsArticle article;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: SizedBox(
        height: height, // pakai height dinamis
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              article.image,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: const Color(0xFFEFEFEF),
                    alignment: Alignment.center,
                    child: const Text('No image'),
                  ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TagChip(text: article.category),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
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

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.86),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
    );
  }
}

/* ================== MODELS ================== */

class NewsArticle {
  final int id;
  final String title;
  final String summary;
  final String category;
  final String source;
  final DateTime date;
  final String image;
  final bool isPopular;
  final bool isFeatured;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.source,
    required this.date,
    required this.image,
    required this.isPopular,
    required this.isFeatured,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> j) => NewsArticle(
    id: j['id'] as int,
    title: j['title'] as String,
    summary: j['summary'] as String,
    category: j['category'] as String,
    source: j['source'] as String,
    date: DateTime.parse(j['date'] as String),
    image: j['image'] as String,
    isPopular: j['isPopular'] as bool? ?? false,
    isFeatured: j['isFeatured'] as bool? ?? false,
  );
}

class _NewsData {
  final List<NewsArticle> all;
  final List<String> categories;
  final NewsArticle featured;
  final List<NewsArticle> popular;

  _NewsData({
    required this.all,
    required this.categories,
    required this.featured,
    required this.popular,
  });
}
