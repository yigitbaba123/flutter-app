import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const StockRadarApp());
}

class StockRadarApp extends StatefulWidget {
  const StockRadarApp({Key? key}) : super(key: key);

  @override
  State<StockRadarApp> createState() => _StockRadarAppState();
}

class _StockRadarAppState extends State<StockRadarApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(() {
      setState(() {}); // Tema değiştiğinde tüm uygulamayı yeniden çiz
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockRadar',
      debugShowCheckedModeBanner: false,
      theme: _themeProvider.themeData,
      home: SplashScreen(themeProvider: _themeProvider),
    );
  }
}
