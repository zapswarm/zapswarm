import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/spark.dart';

class ZapScreen extends StatefulWidget {
  const ZapScreen({super.key});

  @override
  _ZapScreenState createState() => _ZapScreenState();
}

class _ZapScreenState extends State<ZapScreen> {
  List<Spark> sparks = [];
  int zapsToday = 0;
  int swarmingNow = 0;
  Color sparkColor = Colors.white;
  bool isPulsing = false;
  bool isDarkMode = true;
  bool showGlow = false;
  Map<String, int> leaderboard = {"You": 0};
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (swarmingNow < 50) {
        setState(() {
          sparks.add(Spark(color: Colors.white));
          swarmingNow++;
          leaderboard["Global"] = (leaderboard["Global"] ?? 0) + 1;
        });
      }
    });
    Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() => isPulsing = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => isPulsing = false);
      });
    });
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var spark in sparks) {
          spark.x += spark.dx;
          spark.y += spark.dy;
          if (spark.x < 0 || spark.x > MediaQuery.of(context).size.width) spark.dx *= -1;
          if (spark.y < 0 || spark.y > MediaQuery.of(context).size.height) spark.dy *= -1;
        }
      });
    });
  }

  void _zap() {
    setState(() {
      zapsToday++;
      swarmingNow++;
      sparks.add(Spark(color: sparkColor));
      leaderboard["You"] = zapsToday;
      showGlow = true;
    });
    audioPlayer.play(AssetSource('zap_sound.mp3'));
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => showGlow = false);
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() => swarmingNow--);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          ...sparks.map((spark) => spark.build(context, isPulsing)).toList(),
          if (showGlow)
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Text(
              "Zaps Today: $zapsToday | Swarming Now: $swarmingNow",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: _zap,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.blue.shade900, Colors.blue.shade300]
                        : [Colors.blue.shade300, Colors.blue.shade900],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode ? Colors.blue.withValues(alpha: 0.5) : Colors.grey,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Zap Now",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorButton(Colors.white),
                _colorButton(Colors.blue),
                _colorButton(Colors.red),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.share, color: isDarkMode ? Colors.white : Colors.blue, size: 30),
              onPressed: () {
                Share.share("I zapped with $swarmingNow people! Join me on ZapSwarm!");
              },
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.nightlight,
                color: isDarkMode ? Colors.white : Colors.blue,
                size: 30,
              ),
              onPressed: () {
                setState(() => isDarkMode = !isDarkMode);
              },
            ),
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.leaderboard, color: isDarkMode ? Colors.white : Colors.blue, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Top Zappers Today"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: leaderboard.entries.map((entry) {
                        return Text("${entry.key}: ${entry.value} zaps",
                            style: const TextStyle(fontSize: 16));
                      }).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close", style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => sparkColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: sparkColor == color ? (isDarkMode ? Colors.white : Colors.blue) : Colors.grey,
            width: sparkColor == color ? 4 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.grey.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.3),
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}