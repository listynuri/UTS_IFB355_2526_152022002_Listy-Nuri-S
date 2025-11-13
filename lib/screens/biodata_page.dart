// lib/screens/biodata_page.dart
import 'package:flutter/material.dart';
import 'package:uts_listyapp/screens/soft_app_bar.dart';
import '../theme.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});
  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  // controllers
  final _name = TextEditingController(text: 'Listy Nuri S.');
  final _nim = TextEditingController(text: '152022002');
  final _email = TextEditingController(text: 'listy@example.com');
  final _telp = TextEditingController(text: '0812-1234-5678');
  final _alamat = TextEditingController(text: 'Jl. Kenangan No. 27, Bandung');

  // 🔎 search
  final _searchCtrl = TextEditingController();
  String _query = '';

  // states
  String _gender = 'Perempuan';
  String _prodi = 'Informatika';
  DateTime? _birth = DateTime(2004, 7, 12);

  final _prodis = const [
    'Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Teknik Elektro',
    'Lainnya',
  ];

  String _fmt(DateTime? d) =>
      d == null
          ? '-'
          : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _email.dispose();
    _telp.dispose();
    _alamat.dispose();
    _searchCtrl.dispose(); // 🔎
    super.dispose();
  }

  Future<void> _editTextDialog({
    required String title,
    required TextEditingController controller,
    IconData? leadingIcon,
    TextInputType? keyboardType,
  }) async {
    final tmp = TextEditingController(text: controller.text);
    final res = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text('Edit $title'),
              ],
            ),
            content: TextField(
              controller: tmp,
              keyboardType: keyboardType,
              autofocus: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                isDense: true,
                hintText: title,
                prefixIcon: leadingIcon == null ? null : Icon(leadingIcon),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
    if (res == true) setState(() => controller.text = tmp.text);
  }

  Future<void> _editProdiDialog() async {
    String tmp = _prodi;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setLocal) => AlertDialog(
                  title: Row(
                    children: const [
                      Icon(Icons.school, size: 20),
                      SizedBox(width: 8),
                      Text('Edit Program Studi'),
                    ],
                  ),
                  content: DropdownButtonFormField<String>(
                    value: tmp,
                    items:
                        _prodis
                            .map(
                              (p) => DropdownMenuItem(value: p, child: Text(p)),
                            )
                            .toList(),
                    onChanged: (v) => setLocal(() => tmp = v ?? tmp),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
          ),
    );
    if (saved == true) setState(() => _prodi = tmp);
  }

  Future<void> _editGenderDialog() async {
    String tmp = _gender;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setLocal) => AlertDialog(
                  title: Row(
                    children: const [
                      Icon(Icons.wc, size: 20),
                      SizedBox(width: 8),
                      Text('Edit Jenis Kelamin'),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        value: 'Perempuan',
                        groupValue: tmp,
                        title: const Text('Perempuan'),
                        onChanged: (v) => setLocal(() => tmp = v!),
                      ),
                      RadioListTile<String>(
                        value: 'Laki-laki',
                        groupValue: tmp,
                        title: const Text('Laki-laki'),
                        onChanged: (v) => setLocal(() => tmp = v!),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
          ),
    );
    if (saved == true) setState(() => _gender = tmp);
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1970),
      lastDate: DateTime(now.year + 1),
      helpText: 'Pilih Tanggal Lahir',
    );
    if (picked != null) setState(() => _birth = picked);
  }

  @override
  Widget build(BuildContext context) {
    final textDark = AppColors.textDark;

    final personalItems = [
      _Item(
        icon: Icons.person,
        label: 'Nama',
        value: _name.text,
        onEdit:
            () => _editTextDialog(
              title: 'Nama',
              controller: _name,
              leadingIcon: Icons.person,
            ),
      ),
      _Item(
        icon: Icons.badge_outlined,
        label: 'NIM',
        value: _nim.text,
        onEdit:
            () => _editTextDialog(
              title: 'NIM',
              controller: _nim,
              keyboardType: TextInputType.number,
              leadingIcon: Icons.badge_outlined,
            ),
      ),
      _Item(
        icon: Icons.school,
        label: 'Program Studi',
        value: _prodi,
        onEdit: _editProdiDialog,
      ),
      _Item(
        icon: Icons.wc,
        label: 'Jenis Kelamin',
        value: _gender,
        onEdit: _editGenderDialog,
      ),
      _Item(
        icon: Icons.cake_outlined,
        label: 'Tanggal Lahir',
        value: _fmt(_birth),
        onEdit: _pickBirthDate,
      ),
    ];

    final contactItems = [
      _Item(
        icon: Icons.mail_outline,
        label: 'Email',
        value: _email.text,
        onEdit:
            () => _editTextDialog(
              title: 'Email',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              leadingIcon: Icons.mail_outline,
            ),
      ),
      _Item(
        icon: Icons.phone_iphone,
        label: 'No. HP',
        value: _telp.text,
        onEdit:
            () => _editTextDialog(
              title: 'No. HP',
              controller: _telp,
              keyboardType: TextInputType.phone,
              leadingIcon: Icons.phone_iphone,
            ),
      ),
      _Item(
        icon: Icons.location_on_outlined,
        label: 'Alamat',
        value: _alamat.text,
        onEdit:
            () => _editTextDialog(
              title: 'Alamat',
              controller: _alamat,
              leadingIcon: Icons.location_on_outlined,
            ),
      ),
    ];

    // ---------- FILTER BERDASAR QUERY ----------
    List<_Item> _filter(List<_Item> items) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return items;
      return items
          .where(
            (e) =>
                e.label.toLowerCase().contains(q) ||
                e.value.toLowerCase().contains(q),
          )
          .toList();
    }

    final filteredPersonal = _filter(personalItems);
    final filteredContact = _filter(contactItems);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SoftTopBar(
        title: 'Profile',
        roundAll: true,
        horizontalMargin: 12,
        onBack: () {
          final nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.pop();
          } else {
            nav.pushNamedAndRemoveUntil('/dashboard', (route) => false);
          }
        },
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeaderCard(name: _name.text, nim: _nim.text, prodi: _prodi),
              const SizedBox(height: 16),

              // 🔎 SEARCH BAR
              TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Cari (nama, email, nim, alamat, dsb)…',
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
                  fillColor: const Color(0xFFF7F7FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE6E6EC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE6E6EC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD0D0D7)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),

              const SizedBox(height: 16),

              if (filteredPersonal.isNotEmpty) ...[
                Text(
                  'Data Pribadi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),
                ...filteredPersonal.map(
                  (e) => _ReadTileEditable(
                    icon: e.icon,
                    label: e.label,
                    value: e.value,
                    onEdit: e.onEdit,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (filteredContact.isNotEmpty) ...[
                Text(
                  'Kontak',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),
                ...filteredContact.map(
                  (e) => _ReadTileEditable(
                    icon: e.icon,
                    label: e.label,
                    value: e.value,
                    onEdit: e.onEdit,
                  ),
                ),
              ],

              if (filteredPersonal.isEmpty && filteredContact.isEmpty) ...[
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Tidak ada data yang cocok dengan pencarian.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/* ======================= MODEL ITEM ======================= */
class _Item {
  final IconData icon;
  final String label;
  final String value;
  final Future<void> Function() onEdit;
  _Item({
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.name,
    required this.nim,
    required this.prodi,
  });
  final String name;
  final String nim;
  final String prodi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F0FF), Color(0xFFFFE8F3), Color(0xFFF0E8FF)],
        ),

        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Text(
              (name.isNotEmpty ? name[0] : 'L').toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Listy 👋',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppColors.textDark),
                ),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoPill(icon: Icons.school, text: 'Prodi $prodi'),
                    const SizedBox(height: 6),
                    _InfoPill(icon: Icons.badge_outlined, text: 'NIM $nim'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class _ReadTileEditable extends StatelessWidget {
  const _ReadTileEditable({
    required this.icon,
    required this.label,
    required this.value,
    required this.onEdit,
  });
  final IconData icon;
  final String label;
  final String value;
  final Future<void> Function() onEdit;

  @override
  Widget build(BuildContext context) {
    final iconColor = AppColors.textDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        // 🌈 pastel blue → pink → purple
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 254, 232, 255),
            Color.fromARGB(255, 254, 255, 226), // soft pink
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1A000000)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(.9),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: onEdit,
          tooltip: 'Edit $label',
        ),
      ),
    );
  }
}
