import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, this.onBack});
  final VoidCallback? onBack;
  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _search = TextEditingController();

  final _all = <_Contact>[
    _Contact(name: 'Rara', phone: '0812-3456-7890', avatarColor: Colors.pink),
    _Contact(
      name: 'Dimas Saputra',
      phone: '0813-1111-2222',
      avatarColor: Colors.indigo,
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    _Contact(
      name: 'Sinta Maharani',
      phone: '0814-2222-3333',
      avatarColor: Colors.deepOrange,
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
    ),
    _Contact(
      name: 'Budi Pratama',
      phone: '0815-3333-4444',
      avatarColor: Colors.green,
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    _Contact(
      name: 'Andi Wijaya',
      phone: '0816-4444-5555',
      avatarColor: Colors.blue,
    ),
    _Contact(
      name: 'Rani Putri',
      phone: '0817-5555-6666',
      avatarColor: Colors.teal,
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
    ),
    _Contact(
      name: 'Fajar Nugraha',
      phone: '0818-6666-7777',
      avatarColor: Colors.red,
      avatarUrl: 'https://i.pravatar.cc/150?img=20',
    ),
    _Contact(
      name: 'Raka Mahendra',
      phone: '0819-7777-8888',
      avatarColor: Colors.cyan,
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
    ),
    _Contact(
      name: 'Zahra Nabila',
      phone: '0821-8888-9999',
      avatarColor: Colors.purple,
      avatarUrl: 'https://i.pravatar.cc/150?img=28',
    ),
    _Contact(
      name: 'Farhan Akbar',
      phone: '0822-9876-5432',
      avatarColor: Colors.orange,
    ),
    _Contact(
      name: 'Rika Amelia',
      phone: '0823-8765-4321',
      avatarColor: Colors.blueGrey,
      avatarUrl: 'https://i.pravatar.cc/150?img=53',
    ),
    _Contact(
      name: 'Bagas Aditya',
      phone: '0824-7654-3210',
      avatarColor: Colors.lightGreen,
    ),
    _Contact(
      name: 'Putri Ayu Lestari',
      phone: '0825-6543-2109',
      avatarColor: Colors.amber,
    ),
    _Contact(
      name: 'Riko Prabowo',
      phone: '0826-5432-1098',
      avatarColor: Colors.deepPurple,
      avatarUrl: 'https://i.pravatar.cc/150?img=23',
    ),
    _Contact(
      name: 'Nanda Kirana',
      phone: '0827-4321-0987',
      avatarColor: Colors.lime,
      avatarUrl: 'https://i.pravatar.cc/150?img=48',
    ),
    _Contact(
      name: 'Aldi Firmansyah',
      phone: '0828-3210-9876',
      avatarColor: Colors.pink,
      avatarUrl: 'https://i.pravatar.cc/150?img=14',
    ),
    _Contact(
      name: 'Vina Oktaviani',
      phone: '0829-2109-8765',
      avatarColor: Colors.indigo,
    ),
    _Contact(
      name: 'Rere Anggraini',
      phone: '0831-1098-7654',
      avatarColor: Colors.deepOrange,
      avatarUrl: 'https://i.pravatar.cc/150?img=55',
    ),
    _Contact(
      name: 'Gilang Ramadhan',
      phone: '0832-0198-7654',
      avatarColor: Colors.green,
    ),
    _Contact(
      name: 'Nadia Afifah',
      phone: '0833-9988-7766',
      avatarColor: Colors.blue,
      avatarUrl: 'https://i.pravatar.cc/150?img=29',
    ),
    _Contact(
      name: 'Kevin Hartanto',
      phone: '0834-8877-6655',
      avatarColor: Colors.teal,
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
    ),
    _Contact(
      name: 'Lia Prameswari',
      phone: '0835-7766-5544',
      avatarColor: Colors.red,
      avatarUrl: 'https://i.pravatar.cc/150?img=34',
    ),
    _Contact(
      name: 'Yoga Pratama',
      phone: '0836-6655-4433',
      avatarColor: Colors.cyan,
      avatarUrl: 'https://i.pravatar.cc/150?img=26',
    ),
    _Contact(
      name: 'Rafli Maulana',
      phone: '0837-5544-3322',
      avatarColor: Colors.purple,
      avatarUrl: 'https://i.pravatar.cc/150?img=49',
    ),
    _Contact(
      name: 'Dewi Ayuning',
      phone: '0838-4433-2211',
      avatarColor: Colors.orange,
      avatarUrl: 'https://i.pravatar.cc/150?img=30',
    ),
    _Contact(
      name: 'Aurel Rahma',
      phone: '0839-3322-1100',
      avatarColor: Colors.blueGrey,
    ),
    _Contact(
      name: 'Riza Hidayat',
      phone: '0841-2211-0099',
      avatarColor: Colors.lightGreen,
      avatarUrl: 'https://i.pravatar.cc/150?img=27',
    ),
    _Contact(
      name: 'Nadia Putri',
      phone: '0842-1100-9988',
      avatarColor: Colors.amber,
      avatarUrl: 'https://i.pravatar.cc/150?img=37',
    ),
    _Contact(
      name: 'Rara Aulia',
      phone: '0843-0000-8888',
      avatarColor: Colors.deepPurple,
      avatarUrl: 'https://i.pravatar.cc/150?img=52',
    ),
    _Contact(
      name: 'Bagus Nugroho',
      phone: '0844-1111-2222',
      avatarColor: Colors.brown,
      avatarUrl: 'https://i.pravatar.cc/150?img=21',
    ),
  ];

  late List<_Contact> _shown;
  String _order = 'ASC';

  // ==== CONSTS ====
  static const _headerH = 200.0;
  static const _headerImage = 'assets/images/contacts_header.png';
  static const _pinkFill = Color(0xFFFFE6EE); // search fill
  static const _border = Color(0xFFE8E8E8);

  @override
  void initState() {
    super.initState();
    _shown = List.of(_all);
    _apply();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _apply() {
    final q = _search.text.trim().toLowerCase();
    var r =
        _all.where((c) {
          final n = c.name.toLowerCase();
          final p = c.phone.toLowerCase();
          return q.isEmpty || n.contains(q) || p.contains(q);
        }).toList();

    r.sort((a, b) => a.name.compareTo(b.name));
    if (_order == 'DESC') r = r.reversed.toList();

    setState(() => _shown = r);
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Urutkan',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                RadioListTile<String>(
                  value: 'ASC',
                  groupValue: _order,
                  title: const Text('A → Z (Ascending)'),
                  onChanged: (v) {
                    _order = v!;
                    Navigator.pop(context);
                    _apply();
                  },
                ),
                RadioListTile<String>(
                  value: 'DESC',
                  groupValue: _order,
                  title: const Text('Z → A (Descending)'),
                  onChanged: (v) {
                    _order = v!;
                    Navigator.pop(context);
                    _apply();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _handleBack() async {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeader(
              height: _headerH,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                child: Image.asset(
                  _headerImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder:
                      (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFE9EC), Color(0xFFE9F3FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeader(
              height: 128,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _BackButtonBox(onTap: _handleBack),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Contacts',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 44),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Search (pink) + Sort
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _search,
                              onChanged: (_) => _apply(),
                              decoration: InputDecoration(
                                hintText: 'Cari nama atau nomor…',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon:
                                    _search.text.isEmpty
                                        ? null
                                        : IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            _search.clear();
                                            _apply();
                                          },
                                        ),
                                filled: true,
                                fillColor: _pinkFill,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: _border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: _border),
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
                          InkWell(
                            onTap: _openSortSheet,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: _border),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.sort_by_alpha_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 24 + bottomInset),
            sliver: SliverList.builder(
              itemCount: _shown.length,
              itemBuilder: (context, i) {
                final c = _shown[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFE7EC), Color(0xFFEFF6FF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tileColor: Colors.transparent,
                      leading: _AvatarCircle(contact: c),
                      title: Text(
                        c.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(c.phone),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/dashboard',
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          if (_shown.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: Text('Tidak ada kontak.')),
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.contact});
  final _Contact contact;

  @override
  Widget build(BuildContext context) {
    final bg = contact.avatarColor.withOpacity(.18);
    final fg = contact.avatarColor.shade700;

    if (contact.avatarUrl != null && contact.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: bg,
        foregroundImage: NetworkImage(contact.avatarUrl!),
        onForegroundImageError: (_, __) {},
        child: Text(
          contact.initial,
          style: TextStyle(color: fg, fontWeight: FontWeight.w800),
        ),
      );
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: bg,
      child: Text(
        contact.initial,
        style: TextStyle(color: fg, fontWeight: FontWeight.w800),
      ),
    );
  }
}

/* ===== Tombol Back kotak ===== */
class _BackButtonBox extends StatefulWidget {
  const _BackButtonBox({required this.onTap, super.key});
  final VoidCallback onTap;

  @override
  State<_BackButtonBox> createState() => _BackButtonBoxState();
}

class _BackButtonBoxState extends State<_BackButtonBox> {
  bool _hover = false;
  bool _down = false;

  static const _hoverPink = Color.fromARGB(255, 244, 157, 184);
  static const _border = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    final active = _hover || _down;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onHover: (v) => setState(() => _hover = v),
        onHighlightChanged: (v) => setState(() => _down = v),
        borderRadius: BorderRadius.circular(12),
        splashColor: _hoverPink.withOpacity(.6),
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: active ? _hoverPink : Colors.white,
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back_rounded),
        ),
      ),
    );
  }
}

class _PinnedHeader extends SliverPersistentHeaderDelegate {
  _PinnedHeader({required this.height, required this.child});
  final double height;
  final Widget child;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedHeader oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _Contact {
  final String name;
  final String phone;
  final MaterialColor avatarColor;
  final String? avatarUrl; // ← pakai internet

  _Contact({
    required this.name,
    required this.phone,
    required this.avatarColor,
    this.avatarUrl,
  });

  String get initial => (name.isNotEmpty ? name[0] : '?').toUpperCase();
}
