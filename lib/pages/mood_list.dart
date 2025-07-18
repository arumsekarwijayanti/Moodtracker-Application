import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mood_details_page.dart'; // Import MoodDetailPage

class EmoticonListPage extends StatelessWidget {
  const EmoticonListPage({Key? key}) : super(key: key);

  // Daftar emoticon lengkap sesuai assets
  final List<Map<String, String>> emoticons = const [
    {'image': 'assets/images/angry.png', 'name': 'Marah', 'desc': 'Jangan lupa maafkan.'},
    {'image': 'assets/images/anxious.png', 'name': 'Cemas', 'desc': 'Jangan lupa tarik napas.'},
    {'image': 'assets/images/boring.png', 'name': 'Bosan', 'desc': 'Butuh sesuatu yang baru.'},
    {'image': 'assets/images/calm.png', 'name': 'Tenang', 'desc': 'Tenang itu kunci.'},
    {'image': 'assets/images/cool.png', 'name': 'Keren', 'desc': 'Tetap tenang di segala situasi.'},
    {'image': 'assets/images/excited.png', 'name': 'Semangat', 'desc': 'Penuh energi positif.'},
    {'image': 'assets/images/happy.png', 'name': 'Bahagia', 'desc': 'Selalu ceria!'},
    {'image': 'assets/images/sad.png', 'name': 'Sedih', 'desc': 'Kadang perlu menangis.'},
    {'image': 'assets/images/sleepy.png', 'name': 'Mengantuk', 'desc': 'Saatnya istirahat.'},
    {'image': 'assets/images/sick.png', 'name': 'Sakit', 'desc': 'Lagi gaenak badan.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
              'Daftar Emoji Ekspresimu',
              style: GoogleFonts.quicksand(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDEBF7), Color(0xFFB7E9F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          itemCount: emoticons.length,
          itemBuilder: (context, index) {
            final item = emoticons[index];
            return GestureDetector(
              onTap: () async {
                // Navigasi ke MoodDetailPage dengan parameter mood yang dipilih
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('mood_selected', item['name']!); // Save selected mood for detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoodDetailPage(mood: item['name']!, image: item['image']!),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name']!,
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['desc']!,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
