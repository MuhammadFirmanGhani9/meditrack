import 'package:flutter/material.dart';

import 'widget.dart';
import 'app_data.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final Color primaryColor = const Color(0xFF1E9E8E);

  final AppData appData = AppData.instance;

  String _selectedPeriod = '7 Hari';

  // Menggabungkan tanggal dan waktu jadwal.
  DateTime _scheduleDateTime(MedicineSchedule schedule) {
    final parts = schedule.time.split(':');

    return DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Mengambil jadwal sesuai periode laporan.
  List<MedicineSchedule> get _filteredSchedules {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case '30 Hari':
        startDate = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 29));
        break;
      case '3 Bulan':
        startDate = DateTime(now.year, now.month - 2, 1);
        break;
      default:
        startDate = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 6));
    }

    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return appData.medicineSchedules.where((schedule) {
      final dateTime = _scheduleDateTime(schedule);

      return !dateTime.isBefore(startDate) && !dateTime.isAfter(endDate);
    }).toList();
  }

  // Jadwal yang sudah dikonfirmasi.
  int get totalDikonsumsi {
    return _filteredSchedules.where((item) => item.isTaken).length;
  }

  // Jadwal yang waktunya sudah lewat tetapi belum dikonfirmasi.
  int get totalTerlewat {
    final now = DateTime.now();

    return _filteredSchedules.where((item) {
      return !item.isTaken && !_scheduleDateTime(item).isAfter(now);
    }).length;
  }

  // Jadwal yang waktunya belum tiba.
  int get totalMenunggu {
    final now = DateTime.now();

    return _filteredSchedules.where((item) {
      return !item.isTaken && _scheduleDateTime(item).isAfter(now);
    }).length;
  }

  // Total jadwal yang sudah jatuh tempo.
  int get totalJadwalJatuhTempo {
    return totalDikonsumsi + totalTerlewat;
  }

  double get adherencePercentage {
    if (totalJadwalJatuhTempo == 0) return 0;

    return totalDikonsumsi / totalJadwalJatuhTempo * 100;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getStatus(MedicineSchedule schedule) {
    if (schedule.isTaken) return 'Dikonfirmasi';

    if (!_scheduleDateTime(schedule).isAfter(DateTime.now())) {
      return 'Terlewat';
    }

    return 'Menunggu';
  }

  // Data ringkasan per obat.
  List<Map<String, dynamic>> get _medicineReports {
    final reports = <Map<String, dynamic>>[];

    for (final medicine in appData.medicines) {
      final schedules = _filteredSchedules
          .where((item) => item.medicineId == medicine.id)
          .toList();

      if (schedules.isEmpty) continue;

      final consumed = schedules.where((item) => item.isTaken).length;

      final due = schedules.where((item) {
        return !_scheduleDateTime(item).isAfter(DateTime.now());
      }).length;

      reports.add({'name': medicine.name, 'consumed': consumed, 'total': due});
    }

    return reports;
  }

  // Data grafik berdasarkan periode.
  List<Map<String, dynamic>> get _chartData {
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];

    if (_selectedPeriod == '7 Hari') {
      for (int i = 6; i >= 0; i--) {
        final date = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: i));

        result.add(
          _createChartItem(
            label: _dayName(date.weekday),
            date: date,
            nextDate: date.add(const Duration(days: 1)),
          ),
        );
      }
    } else if (_selectedPeriod == '30 Hari') {
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 29));

      for (int i = 0; i < 5; i++) {
        final date = start.add(Duration(days: i * 7));
        final nextDate = date.add(const Duration(days: 7));

        result.add(
          _createChartItem(label: 'M${i + 1}', date: date, nextDate: nextDate),
        );
      }
    } else {
      for (int i = 2; i >= 0; i--) {
        final date = DateTime(now.year, now.month - i, 1);
        final nextDate = DateTime(date.year, date.month + 1, 1);

        result.add(
          _createChartItem(
            label: _monthName(date.month),
            date: date,
            nextDate: nextDate,
          ),
        );
      }
    }

    return result;
  }

  Map<String, dynamic> _createChartItem({
    required String label,
    required DateTime date,
    required DateTime nextDate,
  }) {
    final schedules = appData.medicineSchedules.where((item) {
      final scheduleDate = _scheduleDateTime(item);

      return !scheduleDate.isBefore(date) &&
          scheduleDate.isBefore(nextDate) &&
          !scheduleDate.isAfter(DateTime.now());
    }).toList();

    final consumed = schedules.where((item) => item.isTaken).length;

    final percentage = schedules.isEmpty
        ? 0.0
        : consumed / schedules.length * 100;

    return {'day': label, 'value': percentage};
  }

  String _dayName(int weekday) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday - 1];
  }

  String _monthName(int month) {
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

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appData,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: const CustomPageTitle(
            title: 'Laporan',
            showBackButton: false,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageDescription(),

                  const SizedBox(height: 20),

                  _buildAdherenceCard(),

                  const SizedBox(height: 18),

                  _buildStatistics(),

                  const SizedBox(height: 25),

                  _buildSectionTitle(
                    'Grafik Konsumsi Obat',
                    'Pantau perkembangan konsumsi obat Anda',
                  ),

                  const SizedBox(height: 14),

                  _buildChartCard(),

                  const SizedBox(height: 25),

                  _buildSectionTitle(
                    'Ringkasan per Obat',
                    'Persentase konsumsi setiap obat',
                  ),

                  const SizedBox(height: 14),

                  _buildMedicineReports(),

                  const SizedBox(height: 25),

                  _buildSectionTitle(
                    'Riwayat Konsumsi',
                    'Aktivitas konsumsi obat terbaru',
                  ),

                  const SizedBox(height: 14),

                  _buildHistory(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Aktivitas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          'Pantau kepatuhan dan riwayat konsumsi obat Anda.',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAdherenceCard() {
    final percentage = adherencePercentage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tingkat Kepatuhan Konsumsi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: Text(
                  'kepatuhan',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 9,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$totalDikonsumsi dari $totalJadwalJatuhTempo jadwal yang jatuh tempo telah dikonfirmasi.',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Dikonsumsi',
            value: '$totalDikonsumsi',
            icon: Icons.check_circle_outline,
            color: primaryColor,
            background: const Color(0xFFE5F5EF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Terlewat',
            value: '$totalTerlewat',
            icon: Icons.cancel_outlined,
            color: Colors.red,
            background: const Color(0xFFFFEBEE),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildChartCard() {
    final chartItems = _chartData;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 7,
            children: ['7 Hari', '30 Hari', '3 Bulan'].map((period) {
              final selected = _selectedPeriod == period;

              return ChoiceChip(
                label: Text(
                  period,
                  style: TextStyle(
                    fontSize: 11,
                    color: selected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selected,
                selectedColor: primaryColor,
                backgroundColor: const Color(0xFFF2F4F5),
                showCheckmark: false,
                onSelected: (_) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 155,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartItems.map((item) {
                final double value = item['value'];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: value / 100,
                              widthFactor: 0.75,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['day'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Grafik dihitung berdasarkan jadwal yang sudah jatuh tempo.',
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineReports() {
    final reports = _medicineReports;

    if (reports.isEmpty) {
      return _buildEmptyState('Belum ada data konsumsi obat.');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: reports.map((medicine) {
          final int consumed = medicine['consumed'];
          final int total = medicine['total'];
          final double percentage = total == 0 ? 0 : consumed / total;

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        medicine['name'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${(percentage * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$consumed dari $total jadwal dikonfirmasi',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistory() {
    final history = List<MedicineSchedule>.from(_filteredSchedules);

    history.sort((a, b) {
      return _scheduleDateTime(b).compareTo(_scheduleDateTime(a));
    });

    if (history.isEmpty) {
      return _buildEmptyState('Belum ada riwayat konsumsi obat.');
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Column(
        children: history.map((schedule) {
          final medicine = appData.getMedicineById(schedule.medicineId);
          final status = _getStatus(schedule);
          final isConfirmed = status == 'Dikonfirmasi';
          final isMissed = status == 'Terlewat';

          final statusColor = isConfirmed
              ? primaryColor
              : isMissed
              ? Colors.red
              : Colors.orange[800]!;

          final statusBackground = isConfirmed
              ? const Color(0xFFE5F5EF)
              : isMissed
              ? const Color(0xFFFFEBEE)
              : const Color(0xFFFFF3E0);

          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5F2),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.medication_outlined,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine?.name ?? 'Obat tidak ditemukan',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${schedule.time} • ${_formatDate(schedule.date)}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(Icons.insert_chart_outlined, color: Colors.grey[400], size: 35),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    );
  }
}
