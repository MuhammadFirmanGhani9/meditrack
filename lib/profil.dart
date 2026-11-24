import 'package:flutter/material.dart';

import 'widget.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final Color primaryColor = const Color(0xFF1E9E8E);

  // Pengaturan sementara
  bool _medicineReminder = true;
  bool _notificationEnabled = true;

  // Data profil dummy
  final Map<String, String> _profile = {
    'name': 'Firman Ridho',
    'email': 'firman.ridho@email.com',
    'phone': '0812-3456-7890',
    'birthDate': '21 Agustus 2005',
    'gender': 'Laki-laki',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomPageTitle(title: 'Profil', showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),

              const SizedBox(height: 25),

              _buildSectionTitle('Informasi Akun'),

              const SizedBox(height: 12),

              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Data Pribadi',
                  subtitle: 'Informasi identitas pengguna',
                  onTap: () => _showPersonalInfo(),
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'Riwayat Aktivitas',
                  subtitle: 'Aktivitas penggunaan aplikasi',
                  onTap: () => _showComingSoon('Riwayat Aktivitas'),
                ),
              ]),

              const SizedBox(height: 24),

              _buildSectionTitle('Pengaturan'),

              const SizedBox(height: 12),

              _buildMenuCard([
                _buildSwitchItem(
                  icon: Icons.medication_outlined,
                  title: 'Pengingat Obat',
                  subtitle: 'Pengingat jadwal konsumsi obat',
                  value: _medicineReminder,
                  onChanged: (value) {
                    setState(() {
                      _medicineReminder = value;
                    });
                  },
                ),
                _buildSwitchItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi',
                  subtitle: 'Aktifkan pemberitahuan aplikasi',
                  value: _notificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationEnabled = value;
                    });
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Pengaturan Aplikasi',
                  subtitle: 'Preferensi aplikasi MediTrack',
                  onTap: () => _showAppSettings(),
                ),
              ]),

              const SizedBox(height: 24),

              _buildSectionTitle('Bantuan dan Informasi'),

              const SizedBox(height: 12),

              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Pusat Bantuan',
                  subtitle: 'Panduan penggunaan MediTrack',
                  onTap: () => _showComingSoon('Pusat Bantuan'),
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'Tentang MediTrack',
                  subtitle: 'Informasi mengenai aplikasi',
                  onTap: () => _showAboutDialog(),
                ),
              ]),

              const SizedBox(height: 24),

              _buildLogoutButton(),

              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    Text(
                      'MediTrack',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Versi 1.0.0',
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // KARTU PROFIL PENGGUNA

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 3),
            ),
            child: Center(
              child: Text(
                _getInitials(_profile['name']!),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 13),

          Text(
            _profile['name']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            _profile['email']!,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Pengguna MediTrack',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.length < 2) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // JUDUL BAGIAN

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // KARTU MENU

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  // ITEM MENU

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            _buildIconContainer(icon),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, color: Colors.grey[400], size: 21),
          ],
        ),
      ),
    );
  }

  // ITEM PENGATURAN DENGAN SWITCH

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      child: Row(
        children: [
          _buildIconContainer(icon),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // IKON MENU

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F2),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: primaryColor, size: 21),
    );
  }

  // DIALOG DATA PRIBADI

  void _showPersonalInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Data Pribadi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              _buildInfoRow('Nama Lengkap', _profile['name']!),
              _buildInfoRow('Email', _profile['email']!),
              _buildInfoRow('Nomor Telepon', _profile['phone']!),
              _buildInfoRow('Tanggal Lahir', _profile['birthDate']!),
              _buildInfoRow('Jenis Kelamin', _profile['gender']!),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // PENGATURAN APLIKASI

  void _showAppSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pengaturan Aplikasi'),
          content: const Text(
            'Pengaturan tambahan seperti tema, bahasa, '
            'dan preferensi tampilan akan tersedia pada '
            'pengembangan berikutnya.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }

  // TENTANG APLIKASI

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'MediTrack',
      applicationVersion: '1.0.0',
      applicationLegalese:
          'Aplikasi Pengingat dan Pemantauan '
          'Konsumsi Obat.',
    );
  }

  // PESAN FITUR SEMENTARA

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan dikembangkan pada tahap berikutnya.'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // TOMBOL KELUAR

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: _confirmLogout,
        icon: const Icon(Icons.logout, size: 19),
        label: const Text(
          'Keluar',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Color(0xFFFFCDD2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar dari MediTrack?'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                _showComingSoon('Fitur keluar akun');
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
