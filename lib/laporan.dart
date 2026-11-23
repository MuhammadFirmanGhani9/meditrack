import 'package:flutter/material.dart';

import 'widget.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final Color primaryColor = const Color(0xFF1E9E8E);

  // Filter periode laporan
  String _selectedPeriod = '7 Hari';

  // Data dummy statistik
  final int totalJadwal = 28;
  final int totalDikonsumsi = 23;
  final int totalBelumDikonfirmasi = 5;

  // Data dummy konsumsi berdasarkan obat
  final List<Map<String, dynamic>> _medicineReports = [
    {'name': 'Amlodipine 5 mg', 'consumed': 10, 'total': 10},
    {'name': 'Metformin 500 mg', 'consumed': 8, 'total': 10},
    {'name': 'Atorvastatin 10 mg', 'consumed': 5, 'total': 8},
  ];

  // Data grafik dummy
  final Map<String, List<Map<String, dynamic>>> _chartData = {
    '7 Hari': [
      {'day': 'Sen', 'value': 65},
      {'day': 'Sel', 'value': 90},
      {'day': 'Rab', 'value': 75},
      {'day': 'Kam', 'value': 100},
      {'day': 'Jum', 'value': 80},
      {'day': 'Sab', 'value': 60},
      {'day': 'Min', 'value': 90},
    ],
    '30 Hari': [
      {'day': 'M1', 'value': 75},
      {'day': 'M2', 'value': 85},
      {'day': 'M3', 'value': 65},
      {'day': 'M4', 'value': 90},
    ],
    '3 Bulan': [
      {'day': 'Sep', 'value': 70},
      {'day': 'Okt', 'value': 80},
      {'day': 'Nov', 'value': 90},
    ],
  };

  // Data dummy riwayat konsumsi
  final List<Map<String, dynamic>> _history = [
    {
      'name': 'Amlodipine 5 mg',
      'time': '08:00',
      'date': '23 November 2026',
      'status': 'Dikonfirmasi',
    },
    {
      'name': 'Metformin 500 mg',
      'time': '13:00',
      'date': '23 November 2026',
      'status': 'Menunggu',
    },
    {
      'name': 'Atorvastatin 10 mg',
      'time': '20:00',
      'date': '22 November 2026',
      'status': 'Dikonfirmasi',
    },
    {
      'name': 'Amlodipine 5 mg',
      'time': '08:00',
      'date': '22 November 2026',
      'status': 'Dikonfirmasi',
    },
  ];

  double get adherencePercentage {
    if (totalJadwal == 0) return 0;
    return totalDikonsumsi / totalJadwal * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomPageTitle(title: 'Laporan', showBackButton: false),
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
  }

  // DESKRIPSI HALAMAN

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

  // KARTU KEPATUHAN

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
            '$totalDikonsumsi dari $totalJadwal jadwal konsumsi '
            'telah dikonfirmasi.',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // KARTU STATISTIK

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
            title: 'Menunggu',
            value: '$totalBelumDikonfirmasi',
            icon: Icons.access_time,
            color: Colors.orange,
            background: const Color(0xFFFFF3E0),
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

  // JUDUL BAGIAN

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

  // GRAFIK KONSUMSI

  Widget _buildChartCard() {
    final chartItems = _chartData[_selectedPeriod]!;

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
                final int value = item['value'];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$value%',
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
            'Grafik ilustrasi berdasarkan data dummy.',
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // RINGKASAN PER OBAT

  Widget _buildMedicineReports() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: _medicineReports.map((medicine) {
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

  // RIWAYAT KONSUMSI

  Widget _buildHistory() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: _cardDecoration(),
      child: Column(
        children: _history.map((item) {
          final bool isConfirmed = item['status'] == 'Dikonfirmasi';

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
                        item['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${item['time']} • ${item['date']}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isConfirmed
                              ? const Color(0xFFE5F5EF)
                              : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['status'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isConfirmed
                                ? primaryColor
                                : Colors.orange[800],
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

  // DEKORASI KARTU

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
    );
  }
}
