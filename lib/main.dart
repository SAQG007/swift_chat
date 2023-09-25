import 'package:flutter/material.dart';
import 'package:swift_chat/config/functions.dart';
import 'package:swift_chat/pages/splash_screen.dart';
import 'package:swift_chat/themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setAppName();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swift Chat',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const SplashScreen(),
    );
  }
}
