import 'package:flutter/material.dart';
import 'user_role.dart'; // <--- TAMBAHKAN INI
import 'signin.dart'; 
import 'signup.dart'; 
import 'main.dart';   

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  final Color primaryColor = const Color(0xFF1E9E8E);
  final Color textColor = const Color(0xFF2D3A3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // ==========================================
                    // BAGIAN LOGO & TEKS APLIKASI
                    // ==========================================
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.medication_liquid, 
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'MediTrack',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Medication Reminder &\nMonitoring System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ==========================================
                    // BAGIAN ILUSTRASI
                    // ==========================================
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_pharmacy, 
                        size: 100,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ==========================================
                    // BAGIAN TOMBOL AKSI (4 TOMBOL)
                    // ==========================================

                    // --- Sub-judul: Masuk ---
                    Text(
                      'Masuk sebagai',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol: Masuk sebagai Care Recipient
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage( // <-- Hapus 'const' jika error
                                userRole: UserRole.careRecipient,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.personal_injury, color: Colors.white, size: 20),
                        label: const Text(
                          'Masuk sebagai Care Recipient',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol: Masuk sebagai Caregiver
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(
                                userRole: UserRole.caregiver,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.health_and_safety, color: Colors.white, size: 20),
                        label: const Text(
                          'Masuk sebagai Caregiver',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: textColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --- Sub-judul: Daftar ---
                    Text(
                      'Daftar sebagai',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol: Daftar sebagai Care Recipient
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(
                                userRole: UserRole.careRecipient,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.personal_injury, color: primaryColor, size: 20),
                        label: Text(
                          'Daftar sebagai Care Recipient',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol: Daftar sebagai Caregiver
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(
                                userRole: UserRole.caregiver,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.health_and_safety, color: textColor, size: 20),
                        label: Text(
                          'Daftar sebagai Caregiver',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: textColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen(),
                          ),
                          (route) => false, 
                        );
                      },
                      child: Text(
                        'Lanjut tanpa akun',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}