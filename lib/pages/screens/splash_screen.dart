import 'dart:async';

import 'package:flutter/material.dart';
import 'disclaimer_screen.dart';
import 'home_screen.dart';

import '../../database/disclamer_database_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkDisclaimerStatus();
  }

  bool _isDisclaimerAcknowledged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text(
              'MIND-MIRROR',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _checkDisclaimerStatus() async {
    final status = await DisclaimerDatabaseHelper.instance
        .getDisclaimerStatus();

    setState(() {
      _isDisclaimerAcknowledged = status;
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => _isDisclaimerAcknowledged
                ? const HomeScreen()
                : const DisclaimerScreen(),
          ),
        );
      }
    });
  }
}
