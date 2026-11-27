import 'package:flutter/material.dart';

import 'widget.dart';
import 'app_data.dart';

const Color primaryColor = Color(0xFF1E9E8E);

// =====================================================
// HALAMAN OBAT SAYA
// =====================================================

class ObatSayaPage extends StatefulWidget {
  const ObatSayaPage({super.key});

  @override
  State<ObatSayaPage> createState() => _ObatSayaPageState();
}

class _ObatSayaPageState extends State<ObatSayaPage> {
  int _selectedTab = 0;
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomPageTitle(title: 'Obat Saya', showBackButton: false),
      body: PageBody(
        padding: EdgeInsets.zero,
        child: ListenableBuilder(
          listenable: AppData.instance,
          builder: (context, child) {
            final medicines = AppData.instance.medicines;

            final activeMedicines = medicines
                .where((medicine) => medicine.isActive)
                .toList();

            final completedMedicines = medicines
                .where((medicine) => !medicine.isActive)
                .toList();

            final selectedMedicines = _selectedTab == 0
                ? activeMedicines
                : completedMedicines;

            final filteredMedicines = selectedMedicines
                .where(
                  (medicine) => medicine.name.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList();

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // SEARCH BAR
                      _buildSearchBar(),

                      const SizedBox(height: 16),

                      // TAB AKTIF DAN SELESAI
                      _buildTabToggle(
                        activeCount: activeMedicines.length,
                        completedCount: completedMedicines.length,
                      ),

                      const SizedBox(height: 16),

                      // DAFTAR OBAT
                      Expanded(
                        child: filteredMedicines.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 90),
                                itemCount: filteredMedicines.length,
                                itemBuilder: (context, index) {
                                  final medicine = filteredMedicines[index];

                                  return _buildMedicineCard(medicine: medicine);
                                },
                              ),
                      ),
                    ],
                  ),
                ),

                // TOMBOL TAMBAH OBAT
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _openAddMedicinePage,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Tambah Obat',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ===================================================
  // SEARCH BAR
  // ===================================================

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Cari obat...',
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  // ===================================================
  // TAB AKTIF DAN SELESAI
  // ===================================================

  Widget _buildTabToggle({
    required int activeCount,
    required int completedCount,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(title: 'Aktif ($activeCount)', index: 0),
          ),
          Expanded(
            child: _buildTabItem(title: 'Selesai ($completedCount)', index: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ===================================================
  // KARTU OBAT
  // ===================================================

  Widget _buildMedicineCard({required Medicine medicine}) {
    final isLowStock = medicine.stock <= medicine.minimumStock;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.medication_rounded,
              color: isLowStock ? const Color(0xFFF5A623) : Colors.grey[500],
              size: 30,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medicine.type,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  'Stok: ${medicine.stock} ${_getStockUnit(medicine.type)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isLowStock ? Colors.orange[800] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: medicine.isActive
                      ? primaryColor.withAlpha(25)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  medicine.isActive ? 'Aktif' : 'Selesai',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: medicine.isActive ? primaryColor : Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
            ],
          ),
        ],
      ),
    );
  }

  String _getStockUnit(String type) {
    switch (type) {
      case 'Sirup':
        return 'botol';
      case 'Kapsul':
        return 'kapsul';
      case 'Tablet':
        return 'tablet';
      default:
        return 'unit';
    }
  }

  // ===================================================
  // KONDISI KETIKA DATA KOSONG
  // ===================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty
                  ? Icons.search_off_rounded
                  : Icons.medication_outlined,
              size: 55,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Obat tidak ditemukan'
                  : _selectedTab == 0
                  ? 'Belum ada obat aktif'
                  : 'Belum ada obat yang selesai',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (_searchQuery.isEmpty && _selectedTab == 0) ...[
              const SizedBox(height: 6),
              Text(
                'Tekan Tambah Obat untuk memulai.',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===================================================
  // NAVIGASI KE FORM TAMBAH OBAT
  // ===================================================

  Future<void> _openAddMedicinePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahObatPage()),
    );
  }
}

// =====================================================
// HALAMAN FORM TAMBAH OBAT
// =====================================================

class TambahObatPage extends StatefulWidget {
  const TambahObatPage({super.key});

  @override
  State<TambahObatPage> createState() => _TambahObatPageState();
}

class _TambahObatPageState extends State<TambahObatPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _usageController = TextEditingController();
  final _stockController = TextEditingController();
  final _minimumStockController = TextEditingController();

  String _selectedType = 'Tablet';

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _usageController.dispose();
    _stockController.dispose();
    _minimumStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomPageTitle(title: 'Tambah Obat', showBackButton: true),
      body: PageBody(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ILUSTRASI / AREA FOTO
              Container(
                height: 125,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Foto Obat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Opsional - belum tersedia',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              _buildLabel('Nama Obat *'),
              _buildTextField(
                controller: _nameController,
                hint: 'Contoh: Amlodipine 5 mg',
                validatorMessage: 'Nama obat wajib diisi',
              ),

              const SizedBox(height: 16),

              _buildLabel('Bentuk Obat *'),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: _inputDecoration(hint: 'Pilih bentuk obat'),
                items: const [
                  DropdownMenuItem(value: 'Tablet', child: Text('Tablet')),
                  DropdownMenuItem(value: 'Kapsul', child: Text('Kapsul')),
                  DropdownMenuItem(value: 'Sirup', child: Text('Sirup')),
                  DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              _buildLabel('Dosis *'),
              _buildTextField(
                controller: _dosageController,
                hint: 'Contoh: 5 mg',
                validatorMessage: 'Dosis wajib diisi',
              ),

              const SizedBox(height: 16),

              _buildLabel('Aturan Penggunaan *'),
              _buildTextField(
                controller: _usageController,
                hint: 'Contoh: 1 tablet setelah makan',
                validatorMessage: 'Aturan penggunaan wajib diisi',
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              _buildLabel('Stok Awal *'),
              _buildTextField(
                controller: _stockController,
                hint: 'Contoh: 30',
                keyboardType: TextInputType.number,
                validatorMessage: 'Stok awal wajib diisi',
              ),

              const SizedBox(height: 16),

              _buildLabel('Batas Minimum Stok *'),
              _buildTextField(
                controller: _minimumStockController,
                hint: 'Contoh: 10',
                keyboardType: TextInputType.number,
                validatorMessage: 'Batas minimum stok wajib diisi',
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Obat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ===================================================
  // LABEL FORM
  // ===================================================

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ===================================================
  // TEXT FIELD
  // ===================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _inputDecoration(hint: hint),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return validatorMessage ?? 'Bagian ini wajib diisi';
        }

        if (keyboardType == TextInputType.number) {
          final number = int.tryParse(value.trim());

          if (number == null || number < 0) {
            return 'Masukkan angka yang valid';
          }
        }

        return null;
      },
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      filled: true,
      fillColor: Colors.white,
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

  // ===================================================
  // SIMPAN DATA OBAT
  // ===================================================

  void _saveMedicine() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final stock = int.parse(_stockController.text.trim());
    final minimumStock = int.parse(_minimumStockController.text.trim());

    if (minimumStock > stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Batas minimum stok tidak boleh melebihi stok awal.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    AppData.instance.addMedicine(
      name: _nameController.text.trim(),
      type: _selectedType,
      dosage: _dosageController.text.trim(),
      usage: _usageController.text.trim(),
      stock: stock,
      minimumStock: minimumStock,
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Obat berhasil ditambahkan.'),
        backgroundColor: primaryColor,
      ),
    );
  }
}
