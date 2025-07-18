import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/splash_screen.dart';
import 'pages/home_page.dart';

// ✅ Feature toggle global
bool isFeatureMoodJournalEnabled = false;

// ✅ Getter untuk akses dari luar (misalnya di home_page.dart)
bool getFeatureToggle() => isFeatureMoodJournalEnabled;

// ✅ Setter (jika ingin mengatur dari test)
void setFeatureToggle(bool value) {
  isFeatureMoodJournalEnabled = value;
}

// ✅ Entry point Flutter (dipanggil dari app_test.dart juga)
void main({bool isTesting = false, bool enableMoodJournal = false}) {
  // Aktifkan toggle hanya saat testing dan permintaan enable = true
  if (isTesting && enableMoodJournal) {
    isFeatureMoodJournalEnabled = true;
  }

  runApp(MoodTrackerApp(
    isTesting: isTesting,
    enableMoodJournal: enableMoodJournal,
  ));
}

class MoodTrackerApp extends StatelessWidget {
  final bool isTesting;
  final bool enableMoodJournal;

  const MoodTrackerApp({
    Key? key,
    this.isTesting = false,
    this.enableMoodJournal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker',
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: isTesting
          ? HomePage(isTesting: true)
          : const SplashPage(), // kalau bukan testing, tampilkan Splashflutter test integration_test/app_test.dart

    );
  }
}
