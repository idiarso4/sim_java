class AppStrings {
  // App Info
  static const String appName = 'SIM Java';
  static const String appVersion = '1.0.0';
  
  // Common
  static const String appTitle = 'Sistem Informasi Manajemen';
  static const String loading = 'Memuat...';
  static const String retry = 'Coba Lagi';
  static const String cancel = 'Batal';
  static const String save = 'Simpan';
  static const String delete = 'Hapus';
  static const String edit = 'Ubah';
  static const String search = 'Cari...';
  static const String noData = 'Tidak ada data';
  static const String errorOccurred = 'Terjadi kesalahan';
  static const String noInternet = 'Tidak ada koneksi internet';
  static const String serverError = 'Gagal terhubung ke server';
  
  // Auth
  static const String login = 'Masuk';
  static const String logout = 'Keluar';
  static const String register = 'Daftar';
  static const String email = 'Email';
  static const String password = 'Kata Sandi';
  static const String confirmPassword = 'Konfirmasi Kata Sandi';
  static const String forgotPassword = 'Lupa Kata Sandi?';
  static const String dontHaveAccount = 'Belum punya akun? ';
  static const String alreadyHaveAccount = 'Sudah punya akun? ';
  static const String loginSuccess = 'Berhasil masuk';
  static const String registerSuccess = 'Berhasil mendaftar';
  static const String invalidEmail = 'Email tidak valid';
  static const String invalidPassword = 'Kata sandi minimal 6 karakter';
  static const String passwordNotMatch = 'Kata sandi tidak cocok';
  static const String fieldRequired = 'Field ini wajib diisi';
  
  // Dashboard
  static const String dashboard = 'Beranda';
  static const String attendance = 'Presensi';
  static const String schedule = 'Jadwal';
  static const String profile = 'Profil';
  static const String settings = 'Pengaturan';
  
  // Attendance
  static const String checkIn = 'Check In';
  static const String checkOut = 'Check Out';
  static const String attendanceHistory = 'Riwayat Presensi';
  static const String attendanceSuccess = 'Presensi berhasil';
  static const String attendanceFailed = 'Presensi gagal';
  static const String attendanceAlready = 'Anda sudah melakukan presensi hari ini';
  static const String attendanceNotInLocation = 'Anda tidak berada di lokasi yang ditentukan';
  
  // Profile
  static const String myProfile = 'Profil Saya';
  static const String editProfile = 'Ubah Profil';
  static const String changePassword = 'Ubah Kata Sandi';
  static const String oldPassword = 'Kata Sandi Lama';
  static const String newPassword = 'Kata Sandi Baru';
  static const String confirmNewPassword = 'Konfirmasi Kata Sandi Baru';
  static const String updateSuccess = 'Berhasil memperbarui';
  static const String updateFailed = 'Gagal memperbarui';
  
  // Settings
  static const String darkMode = 'Mode Gelap';
  static const String language = 'Bahasa';
  static const String about = 'Tentang Aplikasi';
  static const String version = 'Versi';
  static const String privacyPolicy = 'Kebijakan Privasi';
  static const String termsConditions = 'Syarat & Ketentuan';
  static const String helpSupport = 'Bantuan & Dukungan';
  
  // Errors
  static const String errorTitle = 'Terjadi Kesalahan';
  static const String errorMessage = 'Terjadi kesalahan. Silakan coba lagi nanti.';
  static const String noInternetMessage = 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
  static const String serverErrorMessage = 'Tidak dapat terhubung ke server. Silakan coba lagi nanti.';
  static const String unauthorizedMessage = 'Sesi Anda telah berakhir. Silakan masuk kembali.';
  static const String notFoundMessage = 'Data tidak ditemukan.';
  
  // Success
  static const String successTitle = 'Berhasil';
  static const String successMessage = 'Permintaan berhasil diproses.';
  static const String dataSaved = 'Data berhasil disimpan.';
  static const String dataUpdated = 'Data berhasil diperbarui.';
  static const String dataDeleted = 'Data berhasil dihapus.';
  
  // Validation
  static const String validationError = 'Validasi Gagal';
  static const String requiredField = 'Field ini wajib diisi';
  static const String invalidEmailFormat = 'Format email tidak valid';
  static const String passwordMinLength = 'Kata sandi minimal 6 karakter';
  static const String passwordNotMatchMessage = 'Kata sandi tidak cocok';
  
  // Buttons
  static const String ok = 'OK';
  static const String yes = 'Ya';
  static const String no = 'Tidak';
  static const String submit = 'Kirim';
  static const String back = 'Kembali';
  static const String next = 'Selanjutnya';
  static const String skip = 'Lewati';
  static const String done = 'Selesai';
  
  // Date & Time
  static const String today = 'Hari Ini';
  static const String yesterday = 'Kemarin';
  static const String thisWeek = 'Minggu Ini';
  static const String lastWeek = 'Minggu Lalu';
  static const String thisMonth = 'Bulan Ini';
  static const String lastMonth = 'Bulan Lalu';
  static const String customRange = 'Rentang Kustom';
  
  // Months
  static const List<String> months = [
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
  
  // Days
  static const List<String> days = [
    'Minggu',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];
  
  // Short Days
  static const List<String> shortDays = [
    'Min',
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
  ];
}
