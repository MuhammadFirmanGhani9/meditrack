import 'package:flutter/material.dart';

import 'widget.dart';
import 'app_data.dart';

const Color primaryColor = Color(0xFF1E9E8E);

// =====================================================
// HALAMAN JADWAL
// =====================================================

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  // 0 = Jadwal Obat, 1 = Jadwal Kontrol
  int _selectedTab = 0;

  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());

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

              _buildTabToggle(),

              const SizedBox(height: 18),

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

  // ===================================================
  // TAB JADWAL OBAT DAN KONTROL
  // ===================================================

  Widget _buildTabToggle() {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(3),
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
    final isSelected = _selectedTab == index;

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

  // ===================================================
  // JADWAL OBAT
  // ===================================================

  Widget _buildMedicineSchedule() {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, child) {
        final schedules =
            AppData.instance.medicineSchedules
                .where(
                  (schedule) =>
                      DateUtils.isSameDay(schedule.date, _selectedDate),
                )
                .toList()
              ..sort((a, b) => a.time.compareTo(b.time));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendar(),

            const SizedBox(height: 16),

            Divider(color: Colors.grey.shade300),

            const SizedBox(height: 10),

            const Text(
              'Jadwal Obat',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              _formatSelectedDate(_selectedDate),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: schedules.isEmpty
                  ? _buildEmptyState(
                      icon: Icons.medication_outlined,
                      message: 'Belum ada jadwal obat',
                      subtitle:
                          'Tambahkan jadwal konsumsi obat untuk tanggal ini.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];

                        final medicine = AppData.instance.getMedicineById(
                          schedule.medicineId,
                        );

                        if (medicine == null) {
                          return const SizedBox.shrink();
                        }

                        return _buildMedicineCard(
                          scheduleId: schedule.id,
                          time: schedule.time,
                          name: medicine.name,
                          dosage: schedule.dosage,
                          isTaken: schedule.isTaken,
                        );
                      },
                    ),
            ),

            _buildPrimaryButton(
              icon: Icons.add,
              title: 'Tambah Jadwal',
              onPressed: _openAddMedicineSchedule,
            ),

            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  // ===================================================
  // KALENDER MINGGUAN
  // ===================================================

  Widget _buildCalendar() {
    // Menentukan hari Senin pada minggu tanggal terpilih.
    final monday = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday - 1),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.subtract(
                    const Duration(days: 7),
                  );
                });
              },
              icon: const Icon(Icons.chevron_left),
              visualDensity: VisualDensity.compact,
            ),

            Text(
              '${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            IconButton(
              onPressed: () {
                setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 7));
                });
              },
              icon: const Icon(Icons.chevron_right),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final date = monday.add(Duration(days: index));

            final isSelected = DateUtils.isSameDay(date, _selectedDate);

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

  // ===================================================
  // KARTU JADWAL OBAT
  // ===================================================

  Widget _buildMedicineCard({
    required int scheduleId,
    required String time,
    required String name,
    required String dosage,
    required bool isTaken,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 55,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F2),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.medication_outlined,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 10),

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
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      AppData.instance.toggleMedicineTaken(scheduleId);
                    },
                    icon: Icon(
                      isTaken
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isTaken ? primaryColor : Colors.grey[400],
                      size: 24,
                    ),
                    tooltip: isTaken
                        ? 'Batalkan konfirmasi'
                        : 'Konfirmasi konsumsi',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================
  // JADWAL KONTROL
  // ===================================================

  Widget _buildAppointmentSchedule() {
    return ListenableBuilder(
      listenable: AppData.instance,
      builder: (context, child) {
        final appointments = [...AppData.instance.appointments]
          ..sort((a, b) => a.date.compareTo(b.date));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jadwal Kontrol Kesehatan',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              'Kelola jadwal pemeriksaan kesehatan Anda.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: appointments.isEmpty
                  ? _buildEmptyState(
                      icon: Icons.calendar_month_outlined,
                      message: 'Belum ada jadwal kontrol',
                      subtitle: 'Tambahkan jadwal pemeriksaan kesehatan Anda.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        return _buildAppointmentCard(appointments[index]);
                      },
                    ),
            ),

            _buildPrimaryButton(
              icon: Icons.add,
              title: 'Tambah Jadwal Kontrol',
              onPressed: _openAddAppointment,
            ),

            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  // ===================================================
  // KARTU JADWAL KONTROL
  // ===================================================

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
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
                  '${appointment.date.day}',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_monthNames[appointment.date.month - 1]} '
                  '${appointment.date.year}',
                  style: const TextStyle(color: primaryColor, fontSize: 9),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  appointment.hospital,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${_getDayName(appointment.date)} • '
                      '${appointment.time}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 11),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        appointment.location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                    ),
                  ],
                ),

                if (appointment.note.isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    appointment.note,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];

    return days[date.weekday - 1];
  }

  // ===================================================
  // EMPTY STATE
  // ===================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 55, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // TOMBOL UTAMA
  // ===================================================

  Widget _buildPrimaryButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 49,
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
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  // ===================================================
  // NAVIGASI FORM
  // ===================================================

  Future<void> _openAddMedicineSchedule() async {
    if (AppData.instance.medicines
        .where((medicine) => medicine.isActive)
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tambahkan obat aktif terlebih dahulu di halaman Obat Saya.',
          ),
        ),
      );
      return;
    }

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TambahJadwalObatPage(selectedDate: _selectedDate),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _openAddAppointment() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahJadwalKontrolPage()),
    );
  }
}

// =====================================================
// HALAMAN TAMBAH JADWAL OBAT
// =====================================================

class TambahJadwalObatPage extends StatefulWidget {
  final DateTime selectedDate;

  const TambahJadwalObatPage({super.key, required this.selectedDate});

  @override
  State<TambahJadwalObatPage> createState() => _TambahJadwalObatPageState();
}

class _TambahJadwalObatPageState extends State<TambahJadwalObatPage> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedMedicineId;

  final _dosageController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.selectedDate;

    final medicines = AppData.instance.medicines
        .where((medicine) => medicine.isActive)
        .toList();

    if (medicines.isNotEmpty) {
      _selectedMedicineId = medicines.first.id;
      _dosageController.text = medicines.first.dosage;
    }
  }

  @override
  void dispose() {
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicines = AppData.instance.medicines
        .where((medicine) => medicine.isActive)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomPageTitle(
        title: 'Tambah Jadwal',
        showBackButton: true,
      ),
      body: PageBody(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Pilih Obat *'),

              DropdownButtonFormField<int>(
                value: _selectedMedicineId,
                isExpanded: true,
                decoration: _inputDecoration(hint: 'Pilih obat dari Obat Saya'),
                items: medicines.map((medicine) {
                  return DropdownMenuItem<int>(
                    value: medicine.id,
                    child: Text(medicine.name, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMedicineId = value;

                    final medicine = AppData.instance.getMedicineById(value!);

                    _dosageController.text = medicine?.dosage ?? '';
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih obat terlebih dahulu';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _buildLabel('Dosis Konsumsi *'),

              TextFormField(
                controller: _dosageController,
                decoration: _inputDecoration(hint: 'Contoh: 1 tablet'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Dosis konsumsi wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _buildLabel('Tanggal Konsumsi *'),

              _buildPickerField(
                icon: Icons.calendar_month_outlined,
                value: _selectedDate == null
                    ? 'Pilih tanggal'
                    : _formatDate(_selectedDate!),
                onTap: _pickDate,
              ),

              const SizedBox(height: 18),

              _buildLabel('Waktu Konsumsi *'),

              _buildPickerField(
                icon: Icons.access_time,
                value: _selectedTime == null
                    ? 'Pilih waktu konsumsi'
                    : _selectedTime!.format(context),
                onTap: _pickTime,
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F5),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Atur dosis dan waktu berdasarkan petunjuk dokter atau apoteker.',
                        style: TextStyle(color: Colors.grey[800], fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Simpan Jadwal',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // PILIH TANGGAL
  // ---------------------------------------------------

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateUtils.dateOnly(picked);
      });
    }
  }

  // ---------------------------------------------------
  // PILIH WAKTU
  // ---------------------------------------------------

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // ---------------------------------------------------
  // SIMPAN JADWAL OBAT
  // ---------------------------------------------------

  void _saveSchedule() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dan waktu harus dipilih.')),
      );
      return;
    }

    final time =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
        '${_selectedTime!.minute.toString().padLeft(2, '0')}';

    AppData.instance.addMedicineSchedule(
      medicineId: _selectedMedicineId!,
      time: time,
      dosage: _dosageController.text.trim(),
      date: _selectedDate!,
    );

    Navigator.pop(context, true);
  }

  // ---------------------------------------------------
  // WIDGET FORM
  // ---------------------------------------------------

  Widget _buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPickerField({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );
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
}

// =====================================================
// HALAMAN TAMBAH JADWAL KONTROL
// =====================================================

class TambahJadwalKontrolPage extends StatefulWidget {
  const TambahJadwalKontrolPage({super.key});

  @override
  State<TambahJadwalKontrolPage> createState() =>
      _TambahJadwalKontrolPageState();
}

class _TambahJadwalKontrolPageState extends State<TambahJadwalKontrolPage> {
  final _formKey = GlobalKey<FormState>();

  final _doctorController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _doctorController.dispose();
    _hospitalController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomPageTitle(
        title: 'Tambah Jadwal Kontrol',
        showBackButton: true,
      ),
      body: PageBody(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildLabel('Nama Dokter *'),

              _buildTextField(
                controller: _doctorController,
                hint: 'Contoh: Dr. Andi Pratama',
              ),

              const SizedBox(height: 17),

              _buildLabel('Rumah Sakit / Klinik *'),

              _buildTextField(
                controller: _hospitalController,
                hint: 'Contoh: RS Sehat Jaya',
              ),

              const SizedBox(height: 17),

              _buildLabel('Lokasi *'),

              _buildTextField(
                controller: _locationController,
                hint: 'Contoh: Padang, Sumatera Barat',
              ),

              const SizedBox(height: 17),

              _buildLabel('Tanggal Kontrol *'),

              _buildPickerField(
                icon: Icons.calendar_month_outlined,
                value: _selectedDate == null
                    ? 'Pilih tanggal kontrol'
                    : _formatDate(_selectedDate!),
                onTap: _pickDate,
              ),

              const SizedBox(height: 17),

              _buildLabel('Waktu Kontrol *'),

              _buildPickerField(
                icon: Icons.access_time,
                value: _selectedTime == null
                    ? 'Pilih waktu kontrol'
                    : _selectedTime!.format(context),
                onTap: _pickTime,
              ),

              const SizedBox(height: 17),

              _buildLabel('Catatan (Opsional)'),

              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: _inputDecoration(
                  hint: 'Tambahkan catatan pemeriksaan...',
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Simpan Jadwal Kontrol',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------
  // PILIH TANGGAL KONTROL
  // ---------------------------------------------------

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = DateUtils.dateOnly(picked);
      });
    }
  }

  // ---------------------------------------------------
  // PILIH WAKTU KONTROL
  // ---------------------------------------------------

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // ---------------------------------------------------
  // SIMPAN JADWAL KONTROL
  // ---------------------------------------------------

  void _saveAppointment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal dan waktu kontrol harus dipilih.'),
        ),
      );
      return;
    }

    final time =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:'
        '${_selectedTime!.minute.toString().padLeft(2, '0')}';

    AppData.instance.addAppointment(
      doctor: _doctorController.text.trim(),
      hospital: _hospitalController.text.trim(),
      location: _locationController.text.trim(),
      date: _selectedDate!,
      time: time,
      note: _noteController.text.trim(),
    );

    Navigator.pop(context);
  }

  // ---------------------------------------------------
  // WIDGET FORM
  // ---------------------------------------------------

  Widget _buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(hint: hint),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Bagian ini wajib diisi';
        }
        return null;
      },
    );
  }

  Widget _buildPickerField({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );
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
}
