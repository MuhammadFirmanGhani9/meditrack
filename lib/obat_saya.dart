import 'package:flutter/material.dart';
import 'widget.dart'; // Import file widget.dart

class ObatSayaPage extends StatefulWidget {
  const ObatSayaPage({Key? key}) : super(key: key);

  @override
  State<ObatSayaPage> createState() => _ObatSayaPageState();
}

class _ObatSayaPageState extends State<ObatSayaPage> {
  final Color primaryColor = const Color(0xFF1E9E8E);
  
  // State untuk Tab (0 = Aktif, 1 = Selesai)
  int _selectedTab = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // 1. MENGGUNAKAN CUSTOMPAGETITLE DARI WIDGET.DART
      appBar: const CustomPageTitle(
        title: 'Obat Saya',
        showBackButton: false,
      ),

      // 2. MENGGUNAKAN PAGEBODY DARI WIDGET.DART
      body: PageBody(
        padding: EdgeInsets.zero, 
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // --- SEARCH BAR ---
                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  // --- TAB TOGGLE ---
                  _buildTabToggle(),
                  const SizedBox(height: 20),

                  // --- LIST OBAT ---
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80), 
                      children: [
                        if (_selectedTab == 0) ...[
                          _buildMedicineCard(
                            name: 'Amlodipine 5 mg',
                            type: 'Tablet',
                            stock: '18 tablet',
                            iconColor: Colors.grey[400]!,
                            isActive: true,
                          ),
                          _buildMedicineCard(
                            name: 'Metformin 500 mg',
                            type: 'Tablet',
                            stock: '24 tablet',
                            iconColor: Colors.grey[300]!,
                            isActive: true,
                          ),
                          _buildMedicineCard(
                            name: 'Atorvastatin 10 mg',
                            type: 'Tablet',
                            stock: '10 tablet',
                            iconColor: const Color(0xFFF5A623), 
                            isActive: true,
                          ),
                        ] else ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Text(
                                'Belum ada obat yang selesai.',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- TOMBOL TAMBAH OBAT ---
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigasi ke halaman Tambah Obat
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Tambah Obat',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w600,
                        color: Colors.white
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

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari obat...',
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

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
                  'Aktif (3)',
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
                  'Selesai (1)',
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

  Widget _buildMedicineCard({
    required String name,
    required String type,
    required String stock,
    required Color iconColor,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.medication, color: iconColor, size: 30),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  'Stok: $stock',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  // Menggunakan Colors.teal dengan transparansi (pengganti withOpacity)
                  color: isActive ? Colors.teal.withAlpha(25) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? 'Aktif' : 'Selesai',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isActive ? primaryColor : Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
            ],
          ),
        ],
      ),
    );
  }
}