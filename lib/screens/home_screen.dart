import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../services/Location.dart';
import 'weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    if (mounted) {
      // check if the widget's corresponding State object is currently in the widget tree
      _getLocation();
    }
    super.initState();
    print("Init called");
  }

  Future<void> _getLocation() async {
    final loc = Location();
    await loc.getCurrentLocation();
    double lat = loc.latitude!;
    double long = loc.longitude!;
    var apiKey = "6bf02c7c823cb2c74d53c779d2c92e77";
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': lat.toString(),
      'lon': long.toString(),
      'appid': apiKey,
    });
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => weather(weatherdata: data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build method called");
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Climax', style: TextStyle(color: Colors.blue)),
        ),
        backgroundColor: Color(0xFFE0E5EC),
      ),
      body: Center(child: SpinKitWaveSpinner(color: Colors.blue, size: 100.0)),
    );
  }
}
