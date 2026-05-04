import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:self_weather_app/addtionalinfo.dart';
import 'package:self_weather_app/hourlyforcast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyWeatherScreen extends StatefulWidget {
  const MyWeatherScreen({super.key});

  @override
  State<MyWeatherScreen> createState() => _MyWeatherScreenState();
}

class _MyWeatherScreenState extends State<MyWeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final String apiKey = dotenv.env['API_KEY']!;

      String cityName = 'London';

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$apiKey&units=metric',
        ),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(
            // fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),

      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWind = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Card
                SizedBox(
                  width: double.infinity,

                  child: Card(
                    // color: Colors.white10,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(style: BorderStyle.solid, width: 0.25),
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),

                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°C',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 16),

                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),

                              const SizedBox(height: 16),

                              Text(currentSky, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hourly forecast
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForcast = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp = hourlyForcast['main']['temp']
                          .toString();

                      final time = DateTime.parse(
                        hourlyForcast['dt_txt'].toString(),
                      );

                      return Hourlyforcast(
                        time: DateFormat.j().format(time),
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temp: hourlyTemp,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Additional Info
                const Text(
                  'Aditional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Addtionalinfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    Addtionalinfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWind.toString(),
                    ),
                    Addtionalinfo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
