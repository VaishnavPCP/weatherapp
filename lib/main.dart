import 'package:flutter/material.dart';
import 'package:weatherapp/frontpage.dart';

void main() {
  runApp(const Weatherapp());
}
class Weatherapp extends StatefulWidget {
  const Weatherapp({Key? key}) : super(key: key);

  @override
  State<Weatherapp> createState() => _WeatherappState();
}

class _WeatherappState extends State<Weatherapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Frontpage(),
    );
  }
}
