import 'package:flutter/material.dart';

import 'widget.dart';
import 'obat_saya.dart';
import 'jadwal.dart';
import 'laporan.dart';
import 'profil.dart';
import 'auth.dart';
import 'app_data.dart';

void main() {
  runApp(const MediTrackApp());
}

// =====================================================
// APLIKASI UTAMA
// =====================================================

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({super.key});

  static const Color primaryColor = Color(0xFF1E9E8E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FA),
        primaryColor: primaryColor,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const AuthPage(),
    );
  }
}

// =====================================================
// NAVIGASI UTAMA
// =====================================================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateTo(int index) {
    if (index < 0 || index > 4) return;

    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _pages = [
    BerandaPage(onNavigate: _navigateTo),
    const ObatSayaPage(),
    const JadwalPage(),
    const LaporanPage(),
    const ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
      ),
    );
  }
}

// =====================================================
// HALAMAN BERANDA
// =====================================================

class BerandaPage extends StatelessWidget {
  final Function(int) onNavigate;

  BerandaPage({super.key, required this.onNavigate});

  static const Color primaryColor = Color(0xFF1E9E8E);
  static const Color backgroundColor = Color(0xFFF7F9FA);

  final AppData appData = AppData.instance;

  // ---------------------------------------------------
  // FUNGSI TANGGAL DAN WAKTU
  // ---------------------------------------------------

  DateTime _getScheduleDateTime(MedicineSchedule schedule) {
    final parts = schedule.time.split(':');

    return DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  String _formatDate(DateTime date) {
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatDay(DateTime date) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return days[date.weekday - 1];
  }

  // ---------------------------------------------------
  // DATA BERANDA
  // ---------------------------------------------------

  List<MedicineSchedule> get _todaySchedules {
    final today = DateUtils.dateOnly(DateTime.now());

    final schedules = appData.medicineSchedules.where((item) {
      return DateUtils.isSameDay(item.date, today);
    }).toList();

    schedules.sort((a, b) {
      return _getScheduleDateTime(a).compareTo(_getScheduleDateTime(b));
    });

    return schedules;
  }

  List<Appointment> get _upcomingAppointments {
    final now = DateTime.now();

    final appointments = appData.appointments.where((item) {
      final dateTime = DateTime(
        item.date.year,
        item.date.month,
        item.date.day,
        int.parse(item.time.split(':')[0]),
        int.parse(item.time.split(':')[1]),
      );

      return dateTime.isAfter(now);
    }).toList();

    appointments.sort((a, b) {
      return a.date.compareTo(b.date);
    });

    return appointments;
  }

  int get _activeMedicineCount {
    return appData.medicines.where((item) => item.isActive).length;
  }

  int get _lowStockCount {
    return appData.medicines.where((item) {
      return item.isActive && item.stock <= item.minimumStock;
    }).length;
  }

  int get _weeklyTaken {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return appData.medicineSchedules.where((item) {
      final dateTime = _getScheduleDateTime(item);

      return !item.date.isBefore(startOfWeek) &&
          !item.date.isAfter(today) &&
          !dateTime.isAfter(now) &&
          item.isTaken;
    }).length;
  }

  int get _weeklyDue {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return appData.medicineSchedules.where((item) {
      final dateTime = _getScheduleDateTime(item);

      return !item.date.isBefore(startOfWeek) &&
          !item.date.isAfter(today) &&
          !dateTime.isAfter(now);
    }).length;
  }

  double get _weeklyAdherence {
    if (_weeklyDue == 0) return 0;

    return _weeklyTaken / _weeklyDue;
  }

  // ---------------------------------------------------
  // BUILD BERANDA
  // ---------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return SafeArea(
          child: Container(
            color: backgroundColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),

                  const SizedBox(height: 24),

                  _buildAdherenceCard(),

                  const SizedBox(height: 17),

                  _buildStatsRow(),

                  const SizedBox(height: 26),

                  _buildScheduleHeader(),

                  const SizedBox(height: 14),

                  _buildTodaySchedules(),

                  const SizedBox(height: 22),

                  _buildWarningCards(),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===================================================
  // HEADER
  // ===================================================

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 49,
          height: 49,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F5F1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: primaryColor,
            size: 30,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo,',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              SizedBox(height: 2),
              Text(
                'Firman Ridho 👋',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202B2A),
                ),
              ),
            ],
          ),
        ),

        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _showNotifications(context),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.black87,
                    size: 25,
                  ),
                  if (_todaySchedules.any((item) => !item.isTaken))
                    Positioned(
                      right: 10,
                      top: 9,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===================================================
  // KARTU KEPATUHAN
  // ===================================================

  Widget _buildAdherenceCard() {
    final percentage = _weeklyAdherence;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF168E80), Color(0xFF20A795)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.18),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kepatuhan Minggu Ini',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(percentage * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              _buildMiniChart(),
            ],
          ),

          const SizedBox(height: 13),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$_weeklyTaken dari $_weeklyDue jadwal yang sudah jatuh tempo dikonfirmasi',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChart() {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);

    final values = List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));

      final schedules = appData.medicineSchedules.where((item) {
        return DateUtils.isSameDay(item.date, date);
      }).toList();

      final due = schedules.where((item) {
        return !_getScheduleDateTime(item).isAfter(now);
      }).toList();

      if (due.isEmpty) return 0.0;

      final taken = due.where((item) => item.isTaken).length;

      return taken / due.length;
    });

    return SizedBox(
      width: 94,
      height: 43,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.map((value) {
          final height = 9 + (value * 28);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: value > 0 ? 0.95 : 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===================================================
  // KARTU STATISTIK
  // ===================================================

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.medication_rounded,
            count: '$_activeMedicineCount',
            label: 'Obat Aktif',
            color: primaryColor,
            background: const Color(0xFFE5F5F1),
            onTap: () => onNavigate(1),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildStatCard(
            icon: Icons.calendar_month_rounded,
            count: '${_upcomingAppointments.length}',
            label: 'Jadwal Kontrol',
            color: const Color(0xFFF59E0B),
            background: const Color(0xFFFFF4E3),
            onTap: () => onNavigate(2),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 23),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================================================
  // JUDUL JADWAL
  // ===================================================

  Widget _buildScheduleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Obat Hari Ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF202B2A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Jangan lupa konsumsi obat Anda',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),

        TextButton(
          onPressed: () => onNavigate(2),
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Row(
            children: [
              Text(
                'Lihat Semua',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 3),
              Icon(Icons.arrow_forward_ios_rounded, size: 11),
            ],
          ),
        ),
      ],
    );
  }

  // ===================================================
  // DAFTAR JADWAL HARI INI
  // ===================================================

  Widget _buildTodaySchedules() {
    final schedules = _todaySchedules;

    if (schedules.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Icon(
              Icons.event_available_rounded,
              size: 35,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 9),
            const Text(
              'Belum ada jadwal obat hari ini',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              'Jadwal konsumsi obat Anda akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: schedules.map((schedule) {
        final medicine = appData.getMedicineById(schedule.medicineId);

        return _buildScheduleItem(
          schedule: schedule,
          medicine: medicine?.name ?? 'Obat tidak ditemukan',
        );
      }).toList(),
    );
  }

  Widget _buildScheduleItem({
    required MedicineSchedule schedule,
    required String medicine,
  }) {
    final isTaken = schedule.isTaken;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F5F2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.medication_outlined,
              color: primaryColor,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: 48,
            child: Text(
              schedule.time,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF303B39),
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  schedule.dosage,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            tooltip: isTaken ? 'Batalkan konfirmasi' : 'Konfirmasi konsumsi',
            onPressed: () {
              appData.toggleMedicineTaken(schedule.id);
            },
            style: IconButton.styleFrom(
              backgroundColor: isTaken ? primaryColor : Colors.white,
              foregroundColor: isTaken ? Colors.white : Colors.grey[400],
              side: isTaken
                  ? BorderSide.none
                  : BorderSide(color: Colors.grey.shade300),
              fixedSize: const Size(34, 34),
              padding: EdgeInsets.zero,
            ),
            icon: Icon(
              isTaken ? Icons.check_rounded : Icons.circle_outlined,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================
  // KARTU PERINGATAN
  // ===================================================

  Widget _buildWarningCards() {
    final lowStock = _lowStockCount;
    final nearest = _upcomingAppointments.isNotEmpty
        ? _upcomingAppointments.first
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildWarningCard(
            icon: Icons.warning_amber_rounded,
            title: lowStock > 0 ? 'Stok Menipis' : 'Stok Obat',
            subtitle: lowStock > 0
                ? '$lowStock obat perlu diperiksa'
                : 'Stok obat mencukupi',
            color: lowStock > 0 ? const Color(0xFFEA580C) : primaryColor,
            background: lowStock > 0
                ? const Color(0xFFFFF3E7)
                : const Color(0xFFE8F6F2),
            onTap: () => onNavigate(1),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildWarningCard(
            icon: Icons.calendar_month_rounded,
            title: 'Kontrol Terdekat',
            subtitle: nearest == null
                ? 'Belum ada jadwal kontrol'
                : '${_formatDay(nearest.date)}, ${_formatDate(nearest.date)}\n${nearest.hospital}',
            color: const Color(0xFF2563EB),
            background: const Color(0xFFEAF2FE),
            onTap: () => onNavigate(2),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color background,
    required VoidCallback onTap,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 19),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF303B39),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================================================
  // NOTIFIKASI
  // ===================================================

  void _showNotifications(BuildContext context) {
    final schedules = _todaySchedules;
    final pending = schedules.where((item) => !item.isTaken).length;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
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
                  'Notifikasi',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                if (pending > 0)
                  _notificationItem(
                    icon: Icons.medication_outlined,
                    title: 'Pengingat konsumsi obat',
                    description:
                        'Ada $pending jadwal obat hari ini yang belum dikonfirmasi.',
                    color: primaryColor,
                  )
                else
                  _notificationItem(
                    icon: Icons.check_circle_outline,
                    title: 'Jadwal obat hari ini',
                    description:
                        'Semua jadwal obat hari ini sudah dikonfirmasi.',
                    color: primaryColor,
                  ),

                if (_lowStockCount > 0)
                  _notificationItem(
                    icon: Icons.warning_amber_rounded,
                    title: 'Peringatan stok obat',
                    description:
                        'Ada ${_lowStockCount} obat yang stoknya mencapai batas minimum.',
                    color: Colors.orange,
                  ),

                if (_upcomingAppointments.isNotEmpty)
                  _notificationItem(
                    icon: Icons.calendar_month_outlined,
                    title: 'Jadwal kontrol berikutnya',
                    description:
                        '${_upcomingAppointments.first.doctor} • ${_formatDate(_upcomingAppointments.first.date)}',
                    color: Colors.blue,
                  ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: const BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _notificationItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================
  // DEKORASI KARTU
  // ===================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE9EEEE)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.025),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
