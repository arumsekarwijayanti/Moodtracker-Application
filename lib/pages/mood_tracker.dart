import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'mood_journal.dart'; // Import Mood Journal page
import 'mood_save.dart'; // Import the Mood Save page

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({Key? key}) : super(key: key);

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, String> _selectedMoods = {}; // This holds moods for selected dates

  List<String> moods = [
    'assets/images/happy.png',
    'assets/images/sad.png',
    'assets/images/angry.png',
    'assets/images/calm.png',
    'assets/images/excited.png',
    'assets/images/boring.png',
    'assets/images/sleepy.png',
    'assets/images/cool.png',
    'assets/images/anxious.png',
    'assets/images/sick.png',
  ];

  int selectedMoodIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // Save the selected mood on the selected day
  void _saveMood() {
    if (_selectedDay != null) {
      setState(() {
        _selectedMoods[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] = moods[selectedMoodIndex];
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoodSave(mood: moods[selectedMoodIndex]),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mood berhasil disimpan!',
            style: GoogleFonts.quicksand(),
          ),
          backgroundColor: Colors.deepPurpleAccent,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Tulis Catatan',
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MoodJournalPage()),
              );
            },
          ),
        ),
      );
    }
  }

  // Remove the selected mood for the selected day
  void _removeMood() {
    if (_selectedDay != null) {
      setState(() {
        _selectedMoods.remove(DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day));
      });
    }
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'Mood Kamu Di Setiap Bulan',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.pinkAccent.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: const Icon(Icons.arrow_back_ios),
                    rightChevronIcon: const Icon(Icons.arrow_forward_ios),
                  ),
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, focusedDay) {
                      if (_selectedMoods.containsKey(date)) {
                        final mood = _selectedMoods[date]!;

                        return Positioned(
                          bottom: 5,
                          right: 5,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage: AssetImage(mood),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'Mood Kamu Hari Ini?',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.5),
                  onPageChanged: (index) {
                    setState(() {
                      selectedMoodIndex = index;
                    });
                  },
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    Key? moodKey;
                    if (moods[index].contains('happy.png')) {
                      moodKey = const Key('mood_happy');
                    }
                    return GestureDetector(
                      key: moodKey,
                      onTapDown: (details) {},
                      child: Opacity(
                        opacity: selectedMoodIndex == index ? 1.0 : 0.4,
                        child: Image.asset(moods[index], width: 100, height: 100),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0F7),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _cuteButton(
                        text: 'Simpan',
                        color: Colors.deepPurpleAccent,
                        onPressed: _saveMood,
                        key: const Key('button_save_mood'),
                      ),
                      const SizedBox(width: 20),
                      _cuteButton(
                        text: 'Hapus',
                        color: Colors.pinkAccent,
                        onPressed: _removeMood,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cuteButton({required String text, required Color color, required VoidCallback onPressed, Key? key}) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          style: GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
