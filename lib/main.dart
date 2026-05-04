import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:self_weather_app/myweatherscreen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple)),
      home: const MyWeatherScreen(),
    );
  }
}
