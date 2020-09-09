import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:coronaupdate/Models/global_infection_model.dart';
import 'package:coronaupdate/Models/nepal_infection_model.dart';
import 'package:coronaupdate/Screens/global_infection_screen.dart';
import 'package:coronaupdate/Screens/myths_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'news_screen.dart';

Future<NepalInfection> getNepalInfectionData() async {
  String apiEndpoint = "https://nepalcorona.info/api/v1/data";
  String route = "$apiEndpoint/nepal";
  http.Response response = await http.get(route, headers: {
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return NepalInfection.fromJson(data);
  } else {
    throw Exception('Failed to load Data');
  }
}

Future<GlobalInfection> getGlobalInfectionData() async {
  String apiEndpoint = "https://nepalcorona.info/api/v1/data";
  String route = "$apiEndpoint/world";
  http.Response response = await http.get(route, headers: {
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<GlobalInfection> dataList = List();
    dataList = data.map((data) => new GlobalInfection.fromJson(data)).toList();
    return dataList[0];
  } else {
    throw Exception('Failed to load Data');
  }
}

class DashBoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DashBoardScreenState();
  }
}

class DashBoardScreenState extends State<DashBoardScreen> {
  static DateTime now = DateTime.now();
  String formattedTime = DateFormat('kk').format(now);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color(0xFF29B6F6),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            headerView(context),
            Container(
                height: MediaQuery.of(context).size.height * 0.40,
                child: imageCarousel(context)),
            nepalInfectionDisplay(context),
            globalInfectionDisplay(context),
            buildMythsAndNews(context)
          ],
        ),
      ),
    );
  }

  Widget headerView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.lightBlue[200],
            Colors.lightBlue[400],
            Colors.lightBlue[500],
            Colors.lightBlue,
          ],
        ),
      ),
      height: 80.0,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getGreetingText(),
                    Text("Guest",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('App Developed by Binayak Adhikari using Open API from nepalcorona.info'),
                      duration: Duration(seconds: 3),
                    ));
                  },
                  child: CircleAvatar(
                    radius: 20.0,
                    child: Icon(Icons.face),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        child: Carousel(
          boxFit: BoxFit.fill,
          autoplay: true,
          animationCurve: Curves.fastOutSlowIn,
          dotSize: 3.0,
          showIndicator: true,
          dotBgColor: Colors.transparent,
          dotColor: Colors.black38,
          autoplayDuration: Duration(seconds: 4),
          images: [
            AssetImage('assets/images/banner_image0.jpg'),
            AssetImage('assets/images/banner_image1.jpg'),
            AssetImage('assets/images/banner_image2.jpg'),
            AssetImage('assets/images/banner_image3.jpg'),
            AssetImage('assets/images/banner_image4.jpg'),
            AssetImage('assets/images/banner_image5.jpg')
            //ExactAssetImage("assets/images/LaunchImage.jpg")
          ],
        ));
  }

  Widget nepalInfectionDisplay(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          color: Colors.lightBlueAccent,
          height: 160.0,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10.0),
          child: FutureBuilder(
            future: getNepalInfectionData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Text("In Nepal",
                        style: TextStyle(fontSize: 18.0, color: Colors.white)),
                    Divider(),
                    SizedBox(height: 5),
                    Text('Positive Cases : ${snapshot.data.positive}',
                        style: TextStyle(fontSize: 30.0, color: Colors.white)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Negative Cases : ${snapshot.data.negative}',
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Total Test Cases : ${snapshot.data.total}',
                        style: TextStyle(fontSize: 15.0, color: Colors.white))
                  ],
                );
              } else {
                return Column(
                  children: <Widget>[
                    Text("In Nepal",
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    SizedBox(height: 40),
                    Text("Fetching Info...",
                        style: TextStyle(fontSize: 22.0, color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget globalInfectionDisplay(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new GlobalInfectionScreen()));
          },
          child: Container(
            color: Colors.lightBlue[400],
            height: 160.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 10.0),
            child: FutureBuilder(
              future: getGlobalInfectionData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Text("Around the World",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white)),
                      Divider(),
                      SizedBox(height: 5),
                      Text('Total Cases : ${snapshot.data.totalCases}',
                          style:
                              TextStyle(fontSize: 30.0, color: Colors.white)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('New Cases : ${snapshot.data.newCases}',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Total Deaths : ${snapshot.data.totalDeaths}',
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.white)),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text("Fetching Info...",
                          style:
                              TextStyle(fontSize: 22.0, color: Colors.white)),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMythsAndNews(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new MythsScreen()));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width / 2,
            child: Image(
              image: AssetImage('assets/images/corona_myths.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new NewsScreen()));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width / 2,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/corona_news.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget getGreetingText() {
    if (int.parse(formattedTime) >= int.parse("00") &&
        int.parse(formattedTime) < int.parse("12")) {
      return Text(
        "Good Morning",
        style: TextStyle(fontSize: 20),
      );
    } else if (int.parse(formattedTime) >= int.parse("12") &&
        int.parse(formattedTime) <= int.parse("17")) {
      return Text(
        "Good Afternoon",
        style: TextStyle(fontSize: 20),
      );
    } else {
      return Text(
        "Good Evening",
        style: TextStyle(fontSize: 20),
      );
    }
  }
}
