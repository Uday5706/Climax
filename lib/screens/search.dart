import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'weather.dart';

class search extends StatefulWidget {
  const search({super.key});
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  var cityNameFocusNode = FocusNode();
  var cityNameController = TextEditingController();
  String? cityNameError;
  var cityName = "";
  bool _isLoading = false;

  void getWeatherDataFromCityName(String cityName) async {
    setState(() {
      _isLoading = true; // Show the spinner
      cityNameError = null; // Clear any previous error
    });
    var apiKey = "6bf02c7c823cb2c74d53c779d2c92e77";
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': cityName,
      'appid': apiKey,
    });
    print(url);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // Success: Process data and navigate
        var weatherData = jsonDecode(response.body);
        print("Weather data: $weatherData");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => weather(weatherdata: weatherData),
          ),
        );
        // TODO: Navigate to weather screen
      } else if (response.statusCode == 404) {
        setState(() {
          cityNameError = "Invalid city name. Please try again.";
        });
      } else {
        setState(() {
          cityNameError =
              "An error occurred. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        cityNameError = "Failed to connect to the server.";
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide the spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climax', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
        backgroundColor: Color(0xFFE0E5EC),
        // automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFE0E5EC),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 100,
                child: TextField(
                  focusNode: cityNameFocusNode,
                  controller: cityNameController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'City Name',
                    prefixIcon: Icon(Icons.location_city),
                    hintText: 'Enter city name',
                    // labelStyle: TextStyle(color: Colors.blue),
                    errorText: cityNameError,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      cityName = value;
                    });
                  },
                ),
              ),
              // const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (cityName.isEmpty) {
                          setState(() {
                            cityNameError = "Please enter a city name.";
                          });
                        } else {
                          getWeatherDataFromCityName(cityName);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20, // Adjust the size of the spinner
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text("Search"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
