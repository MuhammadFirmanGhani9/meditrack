import 'package:flutter/material.dart';

import 'widget.dart';
import 'obat_saya.dart';
import 'jadwal.dart';
import 'laporan.dart';
import 'profil.dart';
import 'auth.dart'; // <-- Import AuthPage agar jadi halaman pertama

void main() {
  runApp(const MediTrackApp());
}

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primaryColor: const Color(0xFF1E9E8E),
        fontFamily:
            'Poppins', // Pastikan font sudah didaftarkan di pubspec.yaml
      ),
      // Halaman pertama yang dijalankan adalah AuthPage
      home: const AuthPage(),
    );
  }
}

// ==========================================
// HALAMAN UTAMA (HOST NAVIGASI)
// ==========================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const BerandaPage(), // Halaman Beranda (dipisah ke bawah)
    const ObatSayaPage(),
    const JadwalPage(),
    const LaporanPage(),
    const ProfilPage(),
  ];

  // Daftar Judul untuk Custom AppBar (opsional, jika tiap halaman butuh judul di atas)
  final List<String> _titles = [
    'Beranda',
    'Obat Saya',
    'Jadwal',
    'Laporan',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita gunakan IndexedStack agar state halaman tidak ter-reset saat pindah tab
      body: IndexedStack(index: _currentIndex, children: _pages),

      // Memanggil Navbar dari widget.dart
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// ==========================================
// ISI HALAMAN BERANDA (DIPINDAHKAN DARI TADI)
// ==========================================
class BerandaPage extends StatelessWidget {
  const BerandaPage({Key? key}) : super(key: key);

  final Color primaryColor = const Color(0xFF1E9E8E);

  @override
  Widget build(BuildContext context) {
    // Kita bungkus dengan SafeArea dan SingleChildScrollView
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER
            _buildHeader(),
            const SizedBox(height: 24),

            // 2. KARTU KEPATUHAN
            _buildAdherenceCard(),
            const SizedBox(height: 16),

            // 3. KARTU STATISTIK
            _buildStatsRow(),
            const SizedBox(height: 24),

            // 4. JUDUL JADWAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jadwal Obat Hari Ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 5. LIST JADWAL
            _buildScheduleItem(
              time: '08:00',
              medicine: 'Amlodipine 5 mg',
              dosage: '1 tablet',
              isTaken: true,
            ),
            _buildScheduleItem(
              time: '13:00',
              medicine: 'Metformin 500 mg',
              dosage: '1 tablet',
              isTaken: false,
            ),
            _buildScheduleItem(
              time: '20:00',
              medicine: 'Atorvastatin 10 mg',
              dosage: '1 tablet',
              isTaken: false,
            ),
            const SizedBox(height: 24),

            // 6. KARTU PERINGATAN
            Row(
              children: [
                Expanded(
                  child: _buildWarningCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Menipis',
                    subtitle: '1 obat',
                    color: const Color(0xFFF5A623),
                    bgColor: const Color(0xFFFFF4E5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWarningCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Kontrol Terdekat',
                    subtitle: 'Sen, 28 Apr 2025\nRS Sehat Jaya',
                    color: const Color(0xFF4A90E2),
                    bgColor: const Color(0xFFEAF2FA),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Widget Pendukung Beranda (Sama seperti sebelumnya) ---
  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.white, size: 30),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo,',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const Text(
              'Firman Ridho 👋',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const Spacer(),
        Stack(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              color: Colors.grey[800],
              size: 28,
            ),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdherenceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kepatuhan Minggu Ini',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '85%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [15, 25, 20, 35, 30].map((height) {
                  return Container(
                    margin: const EdgeInsets.only(left: 4),
                    width: 8,
                    height: height.toDouble(),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.medication_liquid_rounded,
            count: '3',
            label: 'Obat Aktif',
            iconColor: primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_today_rounded,
            count: '1',
            label: 'Jadwal Kontrol',
            iconColor: const Color(0xFFF5A623),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required String time,
    required String medicine,
    required String dosage,
    required bool isTaken,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isTaken
                  ? primaryColor.withOpacity(0.1)
                  : Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isTaken ? Icons.check_circle : Icons.access_time_filled,
                  size: 14,
                  color: isTaken ? primaryColor : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isTaken ? primaryColor : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dosage,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(
            isTaken ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isTaken ? primaryColor : Colors.grey,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
