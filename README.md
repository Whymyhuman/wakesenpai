# WakeSenpai - Jam Alarm Anime Offline

WakeSenpai adalah aplikasi jam alarm interaktif bertema anime yang dibangun dengan Flutter. Aplikasi ini dirancang untuk membantu Anda bangun tepat waktu dengan tantangan mini-game yang menarik dan pengalaman yang dipersonalisasi.

## Petunjuk Build Manual dan Otomatis

### Cara Setup Proyek

Ikuti langkah-langkah di bawah ini untuk mengatur dan menjalankan proyek WakeSenpai di lingkungan pengembangan Anda.

#### Prasyarat

Pastikan Anda telah menginstal Flutter SDK (versi stabil terbaru) dan Android Studio (atau editor pilihan Anda) dengan plugin Flutter dan Dart.

#### Instalasi

1.  **Clone repositori:**
    ```bash
    git clone https://github.com/Whymyhuman/Wake-senpai.git
    cd Wake-senpai
    ```

2.  **Ambil dependensi:**
    ```bash
    flutter pub get
    ```

3.  **Jalankan build_runner (untuk Hive):**
    ```bash
    flutter packages pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Pastikan perangkat Android terhubung atau emulator berjalan.**

5.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

### Cara Build APK Offline

Untuk membangun file APK rilis untuk Android secara offline:

1.  Pastikan Anda berada di direktori root proyek (`wake_senpai`).
2.  Jalankan perintah berikut:
    ```bash
    flutter build apk --release
    ```
3.  File APK yang sudah jadi akan ditemukan di `build/app/outputs/flutter-apk/app-release.apk`.

### Build APK Otomatis via GitHub Actions

Jika sudah commit ke GitHub repo (`https://github.com/Whymyhuman/Wake-senpai.git`), maka APK otomatis dibuild dan bisa didownload dari tab **Actions > wake_senpai_beta_apk artifact**.

## Petunjuk Input Suara & Ilustrasi

### Tambahkan Gambar Ilustrasi Chibi

Contoh file:

```
assets/images/senpai_chibi_01.png
assets/images/senpai_chibi_02.png
assets/images/senpai_chibi_03.png
```

Tempatkan ilustrasi chibi Anda di direktori `assets/images/`.

### Suara Karakter

Tambahkan file suara `.mp3` atau `.wav` ke dalam:

```
/assets/audio/
```

Contoh nama file:

*   `senpai_bangun_1.mp3`
*   `senpai_bangun_2.mp3`

**Tips**: Anda bisa merekam sendiri atau menggunakan voice AI eksternal untuk mengisi suara ala waifu/senpai (pastikan legal & bebas lisensi).

## Struktur Proyek

```
wake_senpai/
├── lib/
│   ├── models/             # Definisi model data (Alarm, UserStats)
│   ├── viewmodels/         # Logika bisnis dan manajemen state (Provider MVVM)
│   ├── views/              # Komponen UI (layar, widget)
│   ├── services/           # Layanan backend lokal (AlarmService, LocalDbService, dll.)
│   │   ├── audio_service.dart
│   │   ├── alarm_service.dart
│   │   ├── habit_predictor.dart
│   │   └── local_db_service.dart
│   ├── widgets/            # Widget kustom yang dapat digunakan kembali
│   └── utils/              # Utilitas dan fungsi pembantu
├── assets/
│   ├── audio/              # File suara alarm (.mp3/.wav)
│   ├── images/             # Ilustrasi karakter, latar belakang dinamis
│   └── tflite/              # Model TensorFlow Lite (habit_model.tflite)
├── .github/
│   └── workflows/          # Konfigurasi GitHub Actions
│       └── android_beta_build.yml
├── pubspec.yaml            # Dependensi proyek dan metadata
├── README.md               # Dokumentasi proyek
├── .gitignore              # File yang diabaikan oleh Git
├── .metadata               # Metadata proyek
└── ... (file Flutter lainnya)
```

## Fitur Utama

-   **Penjadwal Alarm:** Menggunakan `android_alarm_manager_plus` dan `flutter_local_notifications`.
-   **Layar Bangun (WakeScreen):** Tampilan layar penuh dengan ilustrasi karakter dan kontrol alarm.
-   **Mini-Game Tantangan:** Puzzle (drag-and-drop) dan Gesture (deteksi goyangan HP).
-   **Sistem XP & Unlock:** Beri XP berdasarkan ketepatan bangun, membuka ilustrasi dan suara baru.
-   **Latar Dinamis:** Mengganti latar belakang sesuai waktu (pagi/malam).
-   **Stub Prediktor Kebiasaan:** Integrasi model TensorFlow Lite untuk prediksi waktu tunda.

## Kualitas Kode

-   **Null-safety:** Seluruh kode ditulis dengan null-safety.
-   **Layout Responsif:** Desain UI yang responsif untuk berbagai ukuran layar.
-   **Penanganan Error:** Implementasi penanganan error dasar.
-   **Komentar:** Komentar dalam Bahasa Indonesia di semua service dan ViewModel.

## Pengujian (Stub)

Stub tes untuk service utama akan ditambahkan di direktori `test/`.

-   `test/alarm_service_test.dart`
-   `test/db_service_test.dart`

## Testing

Coba APK di Android 8.0 ke atas. Pastikan:

*   Alarm bisa aktif walau aplikasi ditutup.
*   Suara dan ilustrasi muncul saat alarm.
*   Mini-game bisa dijalankan.
*   XP bertambah saat bangun tepat waktu.


