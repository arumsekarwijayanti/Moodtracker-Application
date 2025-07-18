import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodDetailPage extends StatefulWidget {
  final String mood;
  final String image;

  const MoodDetailPage({super.key, required this.mood, required this.image});

  @override
  State<MoodDetailPage> createState() => _MoodDetailPageState();
}

class _MoodDetailPageState extends State<MoodDetailPage> {
  String? _savedNote = '';
  String _moodDescription = '';

  @override
  void initState() {
    super.initState();
    _loadNote();
    _setMoodDescription();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    final note = prefs.getString('journal_${widget.mood}') ?? '';
    setState(() {
      _savedNote = note;
    });
  }

  void _setMoodDescription() {
    switch (widget.mood) {
      case 'Bahagia':
        _moodDescription = 'Selalu ceria dan penuh kebahagiaan!';
        break;
      case 'Sedih':
        _moodDescription = 'Kadang perlu menangis dan merasakan emosi.';
        break;
      case 'Marah':
        _moodDescription = 'Rasa marah yang perlu dikeluarkan, jangan dipendam.';
        break;
      case 'Cemas':
        _moodDescription = 'Tarik napas dalam-dalam, cemas itu biasa.';
        break;
      case 'Bosan':
        _moodDescription = 'Butuh sesuatu yang baru dan menarik.';
        break;
      case 'Tenang':
        _moodDescription = 'Tenang itu kunci untuk menjaga kestabilan diri.';
        break;
      case 'Keren':
        _moodDescription = 'Tetap tenang, percaya diri, dan keren!';
        break;
      case 'Semangat':
        _moodDescription = 'Energi positif yang mengalir dalam diri!';
        break;
      case 'Mengantuk':
        _moodDescription = 'Waktunya beristirahat dan recharge energi!';
        break;
      case 'Sakit':
        _moodDescription = 'Saatnya merawat tubuh dan memberikan waktu istirahat.';
        break;
      default:
        _moodDescription = 'Mood tidak ditemukan.';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('mood_detail_page'),  // Tambahan key di sini saja
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDEBF7), Color(0xFFB7E9F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.mood,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _moodDescription,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_savedNote != null && _savedNote!.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Jurnal Hari Ini:',
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _savedNote!,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),
                Text(
                  'Belum ada catatan untuk mood ini.',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Kembali',
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}
