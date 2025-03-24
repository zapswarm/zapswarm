import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/zap_screen.dart';

void main() {
  runApp(const ZapSwarmApp());
}

class ZapSwarmApp extends StatelessWidget {
  const ZapSwarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZapSwarm',
      theme: ThemeData(
        textTheme: GoogleFonts.orbitronTextTheme(),
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.orbitronTextTheme(),
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ZapScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "ZapSwarm",
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 48, // Increased for impact
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}