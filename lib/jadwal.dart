import 'package:flutter/material.dart';
import 'widget.dart'; // Import file widget.dart

class JadwalPage extends StatefulWidget {
  const JadwalPage({Key? key}) : super(key: key);

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final Color primaryColor = const Color(0xFF1E9E8E);

  // State untuk Tab Toggle (0 = Jadwal Obat, 1 = Jadwal Kontrol)
  int _selectedTab = 0;
  
  // State untuk tanggal yang dipilih di kalender horizontal
  int _selectedDateIndex = 3; // Default ke hari Kamis (index 3)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 1. MENGGUNAKAN CUSTOMPAGETITLE DARI WIDGET.DART
      appBar: const CustomPageTitle(
        title: 'Jadwal',
        showBackButton: false,
      ),

      // 2. MENGGUNAKAN PAGEBODY DARI WIDGET.DART
      body: PageBody(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // --- TAB TOGGLE ---
                _buildTabToggle(),
                const SizedBox(height: 24),

                // --- KALENDER HORIZONTAL ---
                _buildHorizontalCalendar(),
                const SizedBox(height: 24),

                // --- GARIS PEMISAH (DIVIDER) ---
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: 16),

                // --- JUDUL JADWAL OBAT ---
                const Text(
                  'Jadwal Obat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kamis, 24 Apr 2025',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                // --- TIMELINE JADWAL ---
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 80), // Spasi bawah untuk tombol
                    children: [
                      _buildTimelineItem(
                        time: '08:00',
                        medicine: 'Amlodipine 5 mg',
                        dosage: '1 tablet',
                        isTaken: true,
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        time: '13:00',
                        medicine: 'Metformin 500 mg',
                        dosage: '1 tablet',
                        isTaken: false,
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        time: '20:00',
                        medicine: 'Atorvastatin 10 mg',
                        dosage: '1 tablet',
                        isTaken: false,
                        isLast: true, // Item terakhir, garis vertikalnya berhenti
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // --- TOMBOL TAMBAH JADWAL ---
            Positioned(
              bottom: 10, // Sedikit naik agar tidak terlalu mepet bawah
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigasi ke halaman Tambah Jadwal
                      debugPrint('Tambah Jadwal Ditekan');
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Tambah Jadwal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET PENDUKUNG
  // ==========================================

  Widget _buildTabToggle() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 0),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Jadwal Obat',
                  style: TextStyle(
                    color: _selectedTab == 0 ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 1),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Jadwal Kontrol',
                  style: TextStyle(
                    color: _selectedTab == 1 ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    // Data dummy untuk kalender
    final List<Map<String, String>> dates = [
      {'day': 'Sen', 'date': '21'},
      {'day': 'Sel', 'date': '22'},
      {'day': 'Rab', 'date': '23'},
      {'day': 'Kam', 'date': '24'},
      {'day': 'Jum', 'date': '25'},
      {'day': 'Sab', 'date': '26'},
      {'day': 'Min', 'date': '27'},
    ];

    return Column(
      children: [
        // Header Bulan
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.chevron_left, color: Colors.grey[600]),
            const Text(
              'Apr 2025',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
        const SizedBox(height: 16),
        
        // List Tanggal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dates.length, (index) {
            bool isSelected = _selectedDateIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDateIndex = index;
                });
              },
              child: Container(
                width: 40,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      dates[index]['day']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dates[index]['date']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String medicine,
    required String dosage,
    required bool isTaken,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- KOLOM KIRI (Titik & Garis Vertikal) ---
          SizedBox(
            width: 30,
            child: Column(
              children: [
                // Titik (Dot)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isTaken ? primaryColor : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                // Garis Vertikal (Hanya tampil jika bukan item terakhir)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey[300],
                    ),
                  ),
              ],
            ),
          ),
          
          // --- KOLOM KANAN (Informasi Obat) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Waktu
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Ikon Centang / Kosong
                      Icon(
                        isTaken ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isTaken ? primaryColor : Colors.grey[400],
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Nama Obat & Dosis
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        // Ikon Bel / Jam
                        Icon(Icons.notifications_none, size: 18, color: Colors.grey[600]),
                        const SizedBox(width: 12),
                        Column(
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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