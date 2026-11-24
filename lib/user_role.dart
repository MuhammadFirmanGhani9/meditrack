import 'package:flutter/material.dart';

/// Enum untuk mendefinisikan jenis pengguna aplikasi MediTrack.
enum UserRole {
  careRecipient,
  caregiver,
}

/// Extension untuk mempermudah akses properti terkait role.
extension UserRoleExtension on UserRole {
  /// Nama tampilan role (untuk UI).
  String get displayName {
    switch (this) {
      case UserRole.careRecipient:
        return 'Care Recipient';
      case UserRole.caregiver:
        return 'Caregiver';
    }
  }

  /// Deskripsi singkat role.
  String get description {
    switch (this) {
      case UserRole.careRecipient:
        return 'Pasien yang membutuhkan pengingat obat';
      case UserRole.caregiver:
        return 'Pendamping yang memantau jadwal obat';
    }
  }

  /// Ikon yang merepresentasikan role.
  IconData get icon {
    switch (this) {
      case UserRole.careRecipient:
        return Icons.personal_injury;
      case UserRole.caregiver:
        return Icons.health_and_safety;
    }
  }

  /// Nilai string untuk disimpan ke database / API.
  String get value {
    switch (this) {
      case UserRole.careRecipient:
        return 'care_recipient';
      case UserRole.caregiver:
        return 'caregiver';
    }
  }

  /// Konversi dari string (untuk membaca dari database / API).
  static UserRole fromValue(String value) {
    switch (value) {
      case 'care_recipient':
        return UserRole.careRecipient;
      case 'caregiver':
        return UserRole.caregiver;
      default:
        return UserRole.careRecipient;
    }
  }
}