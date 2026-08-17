import 'package:flutter/material.dart';

import 'features/client/presentation/pages/client_home_page.dart';

void main() {
  runApp(const GymProApp());
}

class GymProApp extends StatelessWidget {
  const GymProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF09090B),
      ),
      home: const ClientHomePage(),
    );
  }
}
