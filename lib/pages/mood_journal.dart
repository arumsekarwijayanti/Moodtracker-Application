import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodJournalPage extends StatefulWidget {
  const MoodJournalPage({super.key});

  @override
  State<MoodJournalPage> createState() => _MoodJournalPageState();
}

class _MoodJournalPageState extends State<MoodJournalPage> {
  final TextEditingController _controller = TextEditingController();
  String _savedNote = '';
  String _todayKey = '';
  String? _selectedMoodIcon;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _todayKey = 'journal_${now.year}_${now.month}_${now.day}';
    _loadNote();
  }

  // Load the note and the selected mood from SharedPreferences
  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    final note = prefs.getString(_todayKey) ?? '';
    final moodIcon = prefs.getString('mood_${_todayKey}') ?? ''; // Get the saved mood icon
    setState(() {
      _savedNote = note;
      _selectedMoodIcon = moodIcon; // Set the saved mood icon
      _controller.text = note;
    });
  }

  // Save the note and selected mood icon to SharedPreferences
  Future<void> _saveNote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todayKey, _controller.text);
    await prefs.setString('mood_${_todayKey}', _selectedMoodIcon ?? ''); // Save the selected mood
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan tersimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFDEBF7), Color(0xFFB7E9F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      'Mood Journal',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.deepPurple,
                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Catatan harian kamu hari ini:',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_selectedMoodIcon != null && _selectedMoodIcon!.isNotEmpty) ...[
                          Image.asset(
                            _selectedMoodIcon!,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                        TextField(
                          key: const Key('edit_text_journal'), // Key untuk input jurnal
                          controller: _controller,
                          maxLines: null,
                          style: GoogleFonts.quicksand(fontSize: 16),
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Tulis perasaan atau kejadian hari ini...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  key: const Key('button_save_journal'), // Key untuk tombol simpan jurnal
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Catatan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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
}
