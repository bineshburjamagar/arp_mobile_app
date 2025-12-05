import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindmirror_flutter/pages/screens/splash_screen.dart';

import 'database/disclamer_database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DisclaimerDatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        colorScheme: .fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const SplashScreen(),
    );
  }
}
