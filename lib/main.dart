
import 'package:flutter/material.dart';
import 'screens/mapa_screen.dart';

void main() {
  runApp(const MapaLocaisApp());
}

class MapaLocaisApp extends StatelessWidget {
  const MapaLocaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa de Locais',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MapaScreen(),
    );
  }
}
