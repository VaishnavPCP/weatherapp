import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weatherapp/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'package:weatherapp/constraints.dart' as k;

class Frontpage extends StatefulWidget {
  const Frontpage({Key? key}) : super(key: key);

  @override
  State<Frontpage> createState() => _FrontpageState();
}
class _FrontpageState extends State<Frontpage> {
   String place='';
//  double? datemonth;
  String current='';
  num? humidity;
  num? pressure;
  num? celsious;
  bool isLoaded=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentlocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "image/weatherimg.jpg",
                ),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                ),
                Text(
                  place,
                  style: textStyle(20, Colors.white, FontWeight.bold),
                ),
               /* Text(
                  datemonth,
                  style: textStyle(20, Colors.white, FontWeight.bold),
                ),*/
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud,
                        size: 80,
                        color: Colors.white,
                      ),
                      Text(
                        current,
                        style: textStyle(20, Colors.white, FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 160,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(
                        'Humidity:${humidity?.toInt()}%',
                        style: textStyle(18, Colors.white, FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                          'Pressure:${pressure?.toInt()}hPa',
                        style: textStyle(18, Colors.white, FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text(
                  "${celsious?.toInt()}°C",
                    style: textStyle(80, Colors.white, FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  getCurrentlocation()async{
    var position=await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if(position!=null){
      print("lat:${position.latitude},long:${position.longitude}");
      getCurrentCityWeather(position);
    }
  }
  getCurrentCityWeather(Position posit)async{
    var client=http.Client();
    var uri="${k.domain}lat=${posit.latitude}&lon=${posit.longitude}&appid=${k.apikey}";
    var url=Uri.parse(uri);
    print(url);
    var response=await client.get(url);
    if(response.statusCode==200){
      var data=response.body;
      var decodeData=jsonDecode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded=true;
      });
    }
  }
  updateUI(var decodedData){

    setState(() {
      if(decodedData==null){
        place="not available";
      //  datemonth=0;
        current="not available";
        humidity=0;
        pressure=0;
        celsious=0;

      }else{
        place=decodedData["name"];
       // datemonth=decodedData[""];
        current=decodedData["weather"][0]["description"];
        humidity=decodedData["main"]["humidity"];
        pressure=decodedData["main"]["pressure"];
        celsious=decodedData["main"]["temp"]-273;

        print(current);

      }
    });
  }
}
