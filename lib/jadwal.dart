import 'package:flutter/material.dart';

import 'widget.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final Color primaryColor = const Color(0xFF1E9E8E);

  // 0 = Jadwal Obat, 1 = Jadwal Kontrol
  int _selectedTab = 0;

  // Tanggal yang dipilih
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());

  // Data dummy jadwal obat
  final List<Map<String, dynamic>> _medicineSchedules = [
    {
      'time': '08:00',
      'name': 'Amlodipine 5 mg',
      'dosage': '1 tablet',
      'taken': true,
    },
    {
      'time': '13:00',
      'name': 'Metformin 500 mg',
      'dosage': '1 tablet',
      'taken': false,
    },
    {
      'time': '20:00',
      'name': 'Atorvastatin 10 mg',
      'dosage': '1 tablet',
      'taken': false,
    },
  ];

  // Data dummy jadwal kontrol
  final List<Map<String, String>> _appointments = [
    {
      'date': '28',
      'month': 'Nov 2026',
      'day': 'Sabtu',
      'time': '09:00',
      'doctor': 'Dr. Andi Pratama',
      'hospital': 'RS Sehat Jaya',
      'location': 'Padang, Sumatera Barat',
      'note': 'Pemeriksaan kesehatan rutin',
    },
    {
      'date': '05',
      'month': 'Des 2026',
      'day': 'Sabtu',
      'time': '10:30',
      'doctor': 'Dr. Siti Rahma',
      'hospital': 'Klinik Sehat Bersama',
      'location': 'Padang, Sumatera Barat',
      'note': 'Kontrol lanjutan',
    },
  ];

  final List<String> _dayNames = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  final List<String> _monthNames = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: const CustomPageTitle(title: 'Jadwal', showBackButton: false),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // TAB JADWAL
              _buildTabToggle(),

              const SizedBox(height: 20),

              // KONTEN BERDASARKAN TAB
              Expanded(
                child: _selectedTab == 0
                    ? _buildMedicineSchedule()
                    : _buildAppointmentSchedule(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TAB JADWAL OBAT DAN JADWAL KONTROL
  // ==========================================

  Widget _buildTabToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildTabItem('Jadwal Obat', 0),
          _buildTabItem('Jadwal Kontrol', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // KONTEN JADWAL OBAT
  // ==========================================

  Widget _buildMedicineSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalendar(),

        const SizedBox(height: 18),

        Divider(color: Colors.grey.shade300),

        const SizedBox(height: 12),

        Text(
          'Jadwal Obat',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          _formatSelectedDate(_selectedDate),
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: _medicineSchedules.length,
            itemBuilder: (context, index) {
              final medicine = _medicineSchedules[index];

              return _buildMedicineCard(
                index: index,
                time: medicine['time'],
                name: medicine['name'],
                dosage: medicine['dosage'],
                isTaken: medicine['taken'],
              );
            },
          ),
        ),

        _buildPrimaryButton(
          icon: Icons.add,
          title: 'Tambah Jadwal',
          onPressed: () {
            _showComingSoon('Form Tambah Jadwal');
          },
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  // ==========================================
  // KALENDER HORIZONTAL
  // ==========================================

  Widget _buildCalendar() {
    final DateTime today = DateUtils.dateOnly(DateTime.now());

    // Awal minggu adalah hari Senin
    final DateTime monday = today.subtract(Duration(days: today.weekday - 1));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Minggu ini',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final date = monday.add(Duration(days: index));

            final bool isSelected = DateUtils.isSameDay(date, _selectedDate);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 39,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _dayNames[index],
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 15,
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

  String _formatSelectedDate(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    return '${days[date.weekday - 1]}, ${date.day} '
        '${_monthNames[date.month - 1]} ${date.year}';
  }

  // ==========================================
  // KARTU JADWAL OBAT
  // ==========================================

  Widget _buildMedicineCard({
    required int index,
    required String time,
    required String name,
    required String dosage,
    required bool isTaken,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WAKTU
          SizedBox(
            width: 55,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // KARTU OBAT
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medication_outlined,
                      color: primaryColor,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          dosage,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isTaken
                                ? const Color(0xFFE5F5EF)
                                : const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isTaken ? 'Sudah dikonfirmasi' : 'Menunggu',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isTaken
                                  ? primaryColor
                                  : Colors.orange[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // TOMBOL KONFIRMASI
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _medicineSchedules[index]['taken'] = !isTaken;
                      });
                    },
                    icon: Icon(
                      isTaken
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isTaken ? primaryColor : Colors.grey[400],
                      size: 25,
                    ),
                    tooltip: 'Ubah status konsumsi',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KONTEN JADWAL KONTROL
  // ==========================================

  Widget _buildAppointmentSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Kontrol Kesehatan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        Text(
          'Kelola jadwal pemeriksaan kesehatan Anda.',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: ListView.builder(
            itemCount: _appointments.length,
            itemBuilder: (context, index) {
              final appointment = _appointments[index];

              return _buildAppointmentCard(appointment);
            },
          ),
        ),

        _buildPrimaryButton(
          icon: Icons.add,
          title: 'Tambah Jadwal Kontrol',
          onPressed: () {
            _showComingSoon('Form Tambah Kontrol');
          },
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildAppointmentCard(Map<String, String> appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 55,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      appointment['date']!,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      appointment['month']!,
                      style: TextStyle(color: primaryColor, fontSize: 10),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['doctor']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      appointment['hospital']!,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.access_time, size: 15, color: primaryColor),
                        const SizedBox(width: 5),
                        Text(
                          '${appointment['day']} • ${appointment['time']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey[600],
                size: 17,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  appointment['location']!,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            appointment['note']!,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TOMBOL UTAMA
  // ==========================================

  Widget _buildPrimaryButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 1,
        ),
      ),
    );
  }

  // ==========================================
  // PESAN SEMENTARA
  // ==========================================

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan dibuat pada tahap berikutnya.'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
