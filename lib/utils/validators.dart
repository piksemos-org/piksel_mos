import 'package:flutter/services.dart';

/// Class `Validators` berisi kumpulan method statis untuk validasi input form.
/// Setiap method mengembalikan `String` pesan error jika tidak valid, atau `null` jika valid.
class Validators {
  /// 3a. Validasi Nama Lengkap (`validateName`)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong.';
    }
    if (value.length < 3) {
      return 'Nama minimal 3 karakter.';
    }
    // RegExp untuk mengecek apakah ada angka atau simbol selain spasi
    if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf dan spasi.';
    }
    return null; // Valid
  }

  /// 3b. Validasi Email (`validateEmail`)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong.';
    }
    // RegExp untuk validasi format email umum
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid.';
    }
    return null; // Valid
  }

  /// 3c. Validasi Nomor Telepon (`validatePhone`)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong.';
    }
    // Hapus spasi atau tanda hubung untuk validasi
    final cleanPhone = value.replaceAll(RegExp(r'[\s-]'), '');

    if (RegExp(r'[^0-9+]').hasMatch(cleanPhone)) {
      return 'Nomor telepon hanya boleh berisi angka.';
    }
    if (!cleanPhone.startsWith('0') && !cleanPhone.startsWith('+62')) {
      return 'Harus diawali dengan 0 atau +62.';
    }
    if (cleanPhone.length < 10 || cleanPhone.length > 14) {
      return 'Panjang nomor telepon minimal 10 digit.';
    }
    // Pengecekan pola tidak wajar
    if (RegExp(r'(.)\1{5,}').hasMatch(cleanPhone) || // 6 digit berulang (e.g., 111111)
        cleanPhone.contains('1234567') ||
        cleanPhone.contains('080808')) {
      return 'Gunakan nomor telepon yang valid.';
    }
    return null; // Valid
  }

  /// 3d. Validasi Password (`validatePassword`)
  static String? validatePassword(String? password, {String? name, String? email}) {
    if (password == null || password.isEmpty) {
      return 'Password tidak boleh kosong.';
    }
    if (password.length < 8) {
      return 'Password minimal 8 karakter.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Wajib mengandung minimal 1 huruf kapital.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Wajib mengandung minimal 1 angka.';
    }
    if (name != null && name.isNotEmpty && password.toLowerCase() == name.toLowerCase()) {
      return 'Password tidak boleh sama dengan nama.';
    }
    if (email != null && email.isNotEmpty && password.toLowerCase() == email.toLowerCase()) {
      return 'Password tidak boleh sama dengan email.';
    }
    return null; // Valid
  }

  /// 3e. Validasi Konfirmasi Password (`validateConfirmPassword`)
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong.';
    }
    if (password != confirmPassword) {
      return 'Konfirmasi password tidak cocok.';
    }
    return null; // Valid
  }
}


/// 4. Class `Formatters` berisi kumpulan `TextInputFormatter`.
class Formatters {
  /// Formatter ini secara otomatis mengubah huruf pertama setiap kata menjadi kapital.
  static final TextInputFormatter nameCapitalizationFormatter =
  _CapitalizeWordsInputFormatter();
}

class _CapitalizeWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Ubah setiap kata menjadi huruf kapital di awal
    String capitalizedText = newValue.text
        .split(' ')
        .map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    })
        .join(' ');

    return TextEditingValue(
      text: capitalizedText,
      selection: newValue.selection,
    );
  }
}