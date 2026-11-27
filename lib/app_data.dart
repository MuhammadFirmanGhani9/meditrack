import 'package:flutter/material.dart';

// =====================================================
// MODEL DATA OBAT
// =====================================================

class Medicine {
  final int id;
  String name;
  String type;
  String dosage;
  String usage;
  int stock;
  int minimumStock;
  bool isActive;

  Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.usage,
    required this.stock,
    required this.minimumStock,
    this.isActive = true,
  });
}

// =====================================================
// MODEL DATA JADWAL OBAT
// =====================================================

class MedicineSchedule {
  final int id;
  final int medicineId;
  String time;
  String dosage;
  DateTime date;
  bool isTaken;

  MedicineSchedule({
    required this.id,
    required this.medicineId,
    required this.time,
    required this.dosage,
    required this.date,
    this.isTaken = false,
  });
}

// =====================================================
// MODEL DATA JADWAL KONTROL
// =====================================================

class Appointment {
  final int id;
  String doctor;
  String hospital;
  String location;
  DateTime date;
  String time;
  String note;

  Appointment({
    required this.id,
    required this.doctor,
    required this.hospital,
    required this.location,
    required this.date,
    required this.time,
    required this.note,
  });
}

// =====================================================
// PENYIMPANAN DATA SEMENTARA APLIKASI
// =====================================================

class AppData extends ChangeNotifier {
  AppData._();

  static final AppData instance = AppData._();

  int _nextMedicineId = 4;
  int _nextScheduleId = 4;
  int _nextAppointmentId = 3;

  // ---------------------------------------------------
  // DATA OBAT DUMMY
  // ---------------------------------------------------

  final List<Medicine> medicines = [
    Medicine(
      id: 1,
      name: 'Amlodipine 5 mg',
      type: 'Tablet',
      dosage: '1 tablet',
      usage: '1 tablet setelah makan',
      stock: 18,
      minimumStock: 10,
    ),
    Medicine(
      id: 2,
      name: 'Metformin 500 mg',
      type: 'Tablet',
      dosage: '1 tablet',
      usage: '1 tablet setelah makan',
      stock: 24,
      minimumStock: 10,
    ),
    Medicine(
      id: 3,
      name: 'Atorvastatin 10 mg',
      type: 'Tablet',
      dosage: '1 tablet',
      usage: 'Sesuai petunjuk dokter',
      stock: 10,
      minimumStock: 10,
    ),
  ];

  // ---------------------------------------------------
  // DATA JADWAL OBAT DUMMY
  // ---------------------------------------------------

  final List<MedicineSchedule> medicineSchedules = [
    MedicineSchedule(
      id: 1,
      medicineId: 1,
      time: '08:00',
      dosage: '1 tablet',
      date: DateUtils.dateOnly(DateTime.now()),
      isTaken: true,
    ),
    MedicineSchedule(
      id: 2,
      medicineId: 2,
      time: '13:00',
      dosage: '1 tablet',
      date: DateUtils.dateOnly(DateTime.now()),
    ),
    MedicineSchedule(
      id: 3,
      medicineId: 3,
      time: '20:00',
      dosage: '1 tablet',
      date: DateUtils.dateOnly(DateTime.now()),
    ),
  ];

  // ---------------------------------------------------
  // DATA JADWAL KONTROL DUMMY
  // ---------------------------------------------------

  final List<Appointment> appointments = [
    Appointment(
      id: 1,
      doctor: 'Dr. Andi Pratama',
      hospital: 'RS Sehat Jaya',
      location: 'Padang',
      date: DateTime(2026, 11, 28),
      time: '09:00',
      note: 'Pemeriksaan rutin',
    ),
    Appointment(
      id: 2,
      doctor: 'Dr. Siti Rahma',
      hospital: 'Klinik Sehat Bersama',
      location: 'Padang',
      date: DateTime(2026, 12, 5),
      time: '10:30',
      note: 'Kontrol lanjutan',
    ),
  ];

  // ===================================================
  // FUNGSI OBAT
  // ===================================================

  void addMedicine({
    required String name,
    required String type,
    required String dosage,
    required String usage,
    required int stock,
    required int minimumStock,
  }) {
    medicines.add(
      Medicine(
        id: _nextMedicineId++,
        name: name,
        type: type,
        dosage: dosage,
        usage: usage,
        stock: stock,
        minimumStock: minimumStock,
      ),
    );

    notifyListeners();
  }

  // ===================================================
  // FUNGSI JADWAL OBAT
  // ===================================================

  void addMedicineSchedule({
    required int medicineId,
    required String time,
    required String dosage,
    required DateTime date,
  }) {
    medicineSchedules.add(
      MedicineSchedule(
        id: _nextScheduleId++,
        medicineId: medicineId,
        time: time,
        dosage: dosage,
        date: DateUtils.dateOnly(date),
      ),
    );

    notifyListeners();
  }

  void toggleMedicineTaken(int scheduleId) {
    final index = medicineSchedules.indexWhere(
      (schedule) => schedule.id == scheduleId,
    );

    if (index == -1) return;

    medicineSchedules[index].isTaken = !medicineSchedules[index].isTaken;

    notifyListeners();
  }

  // ===================================================
  // FUNGSI JADWAL KONTROL
  // ===================================================

  void addAppointment({
    required String doctor,
    required String hospital,
    required String location,
    required DateTime date,
    required String time,
    required String note,
  }) {
    appointments.add(
      Appointment(
        id: _nextAppointmentId++,
        doctor: doctor,
        hospital: hospital,
        location: location,
        date: date,
        time: time,
        note: note,
      ),
    );

    notifyListeners();
  }

  // ===================================================
  // FUNGSI PENCARIAN DATA OBAT BERDASARKAN ID
  // ===================================================

  Medicine? getMedicineById(int id) {
    for (final medicine in medicines) {
      if (medicine.id == id) {
        return medicine;
      }
    }

    return null;
  }
}
