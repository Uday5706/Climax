import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'NeoBox.dart';
import 'search.dart';

class weather extends StatefulWidget {
  final weatherdata;
  const weather({super.key, this.weatherdata});

  @override
  State<weather> createState() => _WeatherState();
}

class _WeatherState extends State<weather> {
  var emoji = "🤷‍♂️";
  var tempInCel = "0";
  var currentWeather = "Fetching...";
  var cityName = "Unknown";
  var humidity = "Fetching...";
  var windspeed = "x";
  var pressure = "y";

  @override
  void initState() {
    super.initState();
    print("init screen2");
    updateUI(widget.weatherdata);
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactivated screen2");
  }

  String KelvinToCel(var temp) {
    var tempInCel = temp - 273.15;
    return tempInCel.toStringAsFixed(1);
  }

  void getWeatherDataFromCityName(String cityName) async {
    var apiKey = "6bf02c7c823cb2c74d53c779d2c92e77";
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': cityName,
      'appid': apiKey,
    });
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var weatherData = jsonDecode(response.body);
      print(weatherData);
    }
  }

  void updateUI(weatherData) {
    if (weatherData == null) {
      setState(() {
        emoji = "🤷‍♂️";
        tempInCel = "N/A";
        currentWeather = "No data";
        cityName = "Unknown";
      });
      return;
    }

    var weatherid = weatherData['weather'][0]['id'];
    String weatherEmoji = "☀️"; // Default emoji
    if (weatherid > 200 && weatherid < 300) {
      weatherEmoji = "⛈️";
    } else if (weatherid > 300 && weatherid < 400) {
      weatherEmoji = "🌧☔";
    } else if (weatherid > 500 && weatherid < 600) {
      weatherEmoji = "🌧️🌧";
    } else if (weatherid > 600 && weatherid < 700) {
      weatherEmoji = "❄️";
    } else if (weatherid > 700 && weatherid < 800) {
      weatherEmoji = "🌫️";
    } else if (weatherid == 800) {
      weatherEmoji = "☀️";
    } else {
      weatherEmoji = "☁️";
    }

    setState(() {
      emoji = weatherEmoji;
      var temp = weatherData['main']['temp'];
      tempInCel = KelvinToCel(temp);
      currentWeather = weatherData['weather'][0]['main'];
      cityName = weatherData['name'];
      humidity = weatherData['main']['humidity'].toString();
      windspeed = weatherData['wind']['speed'].toString() + " km/h";
      pressure = weatherData['main']['pressure'].toString() + " hpa";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The leading property places a widget on the left side of the AppBar.
        leading: IconButton(
          icon: const Icon(Icons.cloud, color: Colors.blue),
          onPressed: () {
            // Action to perform when the cloud icon is pressed.
            print('Cloud icon pressed!');
          },
        ),
        title: const Text('Climax', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
        backgroundColor: Color(0xFFE0E5EC),
        automaticallyImplyLeading: false,
        // The actions property places a list of widgets on the right side.
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: () {
              // Action to perform when the search icon is pressed.
              Route _createSlideRoute() {
                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const search(), // Your destination screen
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(-1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                );
              }

              // How to use it
              Navigator.of(context).push(_createSlideRoute());
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => search()),
              // );
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cityName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                '$emoji $currentWeather',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NeoBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.4,
                    // height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children: [
                        Text(
                          'Humidity',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          '$humidity %',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
                NeoBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.4,
                    // height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      children: [
                        Text(
                          'Pressure',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          '$pressure',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NeoBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      children: [
                        Text(
                          'Temperature',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          '$tempInCel°C',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
                NeoBox(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      children: [
                        Text(
                          'Windspeed',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Text(
                          '$windspeed',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
