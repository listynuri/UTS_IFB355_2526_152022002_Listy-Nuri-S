import 'package:flutter/material.dart';
import 'package:uts_listyapp/screens/soft_app_bar.dart';
import '../theme.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final _name = TextEditingController(text: 'Listy Nuri S.');
  final _nim = TextEditingController(text: '152022002');
  final _email = TextEditingController(text: 'listy@example.com');
  final _telp = TextEditingController(text: '0812-1234-5678');
  final _alamat = TextEditingController(text: 'Jl. Kenangan No. 27, Bandung');

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
    super.dispose();
  }

  /* ===== Editor di tengah: Text ===== */
  Future<void> _editTextDialog({
    required String title,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) async {
    final tmp = TextEditingController(text: controller.text);
    final saved = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Edit $title'),
            content: SingleChildScrollView(
              child: TextField(
                controller: tmp,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: title,
                  isDense: true,
                ),
                autofocus: true,
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
    if (saved == true) {
      controller.text = tmp.text;
      setState(() {}); // refresh header + list
    }
  }

  /* ===== Editor di tengah: Dropdown Prodi ===== */
  Future<void> _editProdiDialog() async {
    String draft = _prodi;
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Program Studi'),
            content: StatefulBuilder(
              builder:
                  (ctx, setLocal) => DropdownButtonFormField<String>(
                    value: draft,
                    items:
                        _prodis
                            .map(
                              (p) => DropdownMenuItem(value: p, child: Text(p)),
                            )
                            .toList(),
                    onChanged: (v) => setLocal(() => draft = v ?? draft),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
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
    if (ok == true) setState(() => _prodi = draft);
  }

  /* ===== Editor di tengah: Radio Gender ===== */
  Future<void> _editGenderDialog() async {
    String draft = _gender;
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Jenis Kelamin'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Perempuan'),
                  value: 'Perempuan',
                  groupValue: draft,
                  onChanged: (v) => setState(() => draft = v ?? draft),
                ),
                RadioListTile<String>(
                  title: const Text('Laki-laki'),
                  value: 'Laki-laki',
                  groupValue: draft,
                  onChanged: (v) => setState(() => draft = v ?? draft),
                ),
              ],
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
    if (ok == true) setState(() => _gender = draft);
  }

  /* ===== Tanggal lahir (date picker) ===== */
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
              // Header kartu (tanpa tombol edit)
              _HeaderCard(name: _name.text, nim: _nim.text, prodi: _prodi),
              const SizedBox(height: 16),

              Text(
                'Data Pribadi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),

              _ReadTileEditable(
                icon: Icons.person,
                label: 'Nama',
                value: _name.text,
                onEdit: () => _editTextDialog(title: 'Nama', controller: _name),
              ),
              _ReadTileEditable(
                icon: Icons.badge_outlined,
                label: 'NIM',
                value: _nim.text,
                onEdit:
                    () => _editTextDialog(
                      title: 'NIM',
                      controller: _nim,
                      keyboardType: TextInputType.number,
                    ),
              ),
              _ReadTileEditable(
                icon: Icons.school,
                label: 'Program Studi',
                value: _prodi,
                onEdit: _editProdiDialog,
              ),
              _ReadTileEditable(
                icon: Icons.wc,
                label: 'Jenis Kelamin',
                value: _gender,
                onEdit: _editGenderDialog,
              ),
              _ReadTileEditable(
                icon: Icons.cake_outlined,
                label: 'Tanggal Lahir',
                value: _fmt(_birth),
                onEdit: _pickBirthDate,
              ),

              const SizedBox(height: 16),
              Text(
                'Kontak',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),

              _ReadTileEditable(
                icon: Icons.mail_outline,
                label: 'Email',
                value: _email.text,
                onEdit:
                    () => _editTextDialog(
                      title: 'Email',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
              ),
              _ReadTileEditable(
                icon: Icons.phone_iphone,
                label: 'No. HP',
                value: _telp.text,
                onEdit:
                    () => _editTextDialog(
                      title: 'No. HP',
                      controller: _telp,
                      keyboardType: TextInputType.phone,
                    ),
              ),
              _ReadTileEditable(
                icon: Icons.location_on_outlined,
                label: 'Alamat',
                value: _alamat.text,
                onEdit:
                    () => _editTextDialog(title: 'Alamat', controller: _alamat),
              ),

              // tidak ada tombol edit di atas & bawah ✅
            ],
          ),
        ),
      ),
    );
  }
}

/* ======================= SUB WIDGETS ======================= */

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
        gradient: LinearGradient(
          colors: [AppColors.creamy, const Color.fromARGB(255, 247, 232, 231)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8EC), Color(0xFFF4EFDE)], // cream soft
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1A000000)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black87),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
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
