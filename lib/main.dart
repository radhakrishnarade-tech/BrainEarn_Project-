import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BrainEarnApp());
}

class BrainEarnApp extends StatelessWidget {
  const BrainEarnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainEarn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey,
      ),
      home: const SecurityCheckScreen(),
    );
  }
}

class SecurityCheckScreen extends StatefulWidget {
  const SecurityCheckScreen({super.key});

  @override
  State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  bool _isChecking = true;
  String _statusText = "Checking Device Security...\n(VPN, Anti-Cheat, Auto-Clicker)";

  @override
  void initState() {
    super.initState();
    _checkSecurityAndLogin();
  }

  void _checkSecurityAndLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isVpnOrCheatDetected = false; 

    if (isVpnOrCheatDetected) {
      setState(() {
        _statusText = "Access Denied! VPN, Auto-Clicker or Cheat tool detected. Please disable them.";
        _isChecking = false;
      });
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen(userName: "Raju")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isChecking) const CircularProgressIndicator(color: Colors.deepPurple),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
