import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mood_tracker.dart';
import 'mood_list.dart';
import 'mood_journal.dart'; // pastikan halaman ini tersedia
import '../main.dart'; // untuk akses getFeatureToggle()

class HomePage extends StatefulWidget {
  final bool isTesting;
  const HomePage({super.key, this.isTesting = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _rainController;
  late AnimationController _pageTransitionController;
  final List<_RainDrop> rainDrops = [];
  final Random random = Random();

  final List<String> emoticonPaths = [
    'assets/images/happy.png',
    'assets/images/sad.png',
    'assets/images/angry.png',
    'assets/images/anxious.png',
    'assets/images/boring.png',
    'assets/images/cool.png',
    'assets/images/excited.png',
    'assets/images/sick.png',
    'assets/images/calm.png',
    'assets/images/sleepy.png',
  ];

  final Map<String, ui.Image> loadedImages = {};

  @override
  void initState() {
    super.initState();
    _loadImages();

    _pageTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    if (widget.isTesting) {
      _pageTransitionController.value = 1.0;
    } else {
      _pageTransitionController.forward();
    }
  }

  Future<void> _loadImages() async {
    for (String path in emoticonPaths) {
      final ByteData data = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      loadedImages[path] = frame.image;
    }

    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _generateRain();
    setState(() {});
  }

  void _generateRain() {
    for (int i = 0; i < 30; i++) {
      rainDrops.add(
        _RainDrop(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: random.nextDouble() * 0.002 + 0.001,
          size: random.nextDouble() * 40 + 40,
          imagePath: emoticonPaths[random.nextInt(emoticonPaths.length)],
        ),
      );
    }
  }

  @override
  void dispose() {
    _rainController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = CurvedAnimation(
      parent: _pageTransitionController,
      curve: Curves.easeInOut,
    );

    final slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _pageTransitionController, curve: Curves.easeOutCubic));

    return Scaffold(
      body: loadedImages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFDEBF7), Color(0xFFB7E9F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Emoji Rain Animation from Assets
              AnimatedBuilder(
                animation: _rainController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _RainPainter(
                      rainDrops,
                      _rainController.value,
                      loadedImages,
                    ),
                    size: MediaQuery.of(context).size,
                  );
                },
              ),
              // Main Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuButton(
                      context,
                      key: const Key('button_add_mood'),
                      title: 'cek mood kamu hari ini',
                      page: const MoodTrackerPage(),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuButton(
                      context,
                      key: const Key('button_emoticon_list'),
                      title: 'list emoji ekspresimu',
                      page: const EmoticonListPage(),
                    ),
                    if (getFeatureToggle()) ...[
                      const SizedBox(height: 20),
                      _buildMenuButton(
                        context,
                        key: const Key('button_mood_journal'),
                        title: 'Mood Journal',
                        page: const MoodJournalPage(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String title, required Widget page, Key? key}) {
    return ElevatedButton(
      key: key,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE1D5E7),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      onPressed: () {
        _rainController.stop();
        Navigator.of(context).push(_createRoute(page)).then((_) {
          _rainController.repeat();
        });
      },
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

class _RainDrop {
  double x;
  double y;
  double speed;
  double size;
  String imagePath;

  _RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.imagePath,
  });
}

class _RainPainter extends CustomPainter {
  final List<_RainDrop> rainDrops;
  final double animationValue;
  final Map<String, ui.Image> loadedImages;

  _RainPainter(this.rainDrops, this.animationValue, this.loadedImages);

  @override
  void paint(Canvas canvas, Size size) {
    for (var drop in rainDrops) {
      final double dx = drop.x * size.width;
      final double dy = (drop.y + animationValue * 2) % 1.2 * size.height;
      final paintBounds =
      Rect.fromCenter(center: Offset(dx, dy), width: drop.size, height: drop.size);

      final ui.Image? img = loadedImages[drop.imagePath];
      if (img != null) {
        paintImage(
          canvas: canvas,
          rect: paintBounds,
          image: img,
          fit: BoxFit.cover,
          opacity: 0.3,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
