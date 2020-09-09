import 'dart:convert';

import 'package:coronaupdate/Models/global_infection_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<GlobalInfection>> _fetchGlobalInfectionData() async {
  String apiEndpoint = "https://nepalcorona.info/api/v1/data";
  String route = "$apiEndpoint/world";
  http.Response response = await http.get(route, headers: {
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<GlobalInfection> dataList = List();
    dataList = data.map((data) => new GlobalInfection.fromJson(data)).toList();
    return dataList;
  } else {
    throw Exception('Failed to load Data');
  }
}

class GlobalInfectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GlobalInfectionScreenState();
  }
}

class GlobalInfectionScreenState extends State<GlobalInfectionScreen> {
  Future<List<GlobalInfection>> globalInfectionList;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globalInfectionList = _fetchGlobalInfectionData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Global Infection'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return _fetchGlobalInfectionData().then((value) {
            setState(() {
              globalInfectionList = _fetchGlobalInfectionData();
            });
          });
        },
        child: FutureBuilder(
          future: globalInfectionList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text(snapshot.data[index].country == ""
                              ? 'Worldwide'
                              : snapshot.data[index].country,style: TextStyle(fontSize: 20.0),),
                        ),
                        Card(
                          margin: EdgeInsets.all(12.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.all(5.0),
                            height: 160.0,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].newCases.toString(),
                                          style: TextStyle(fontSize: 20.0,color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].totalCases.toString(),
                                          style: TextStyle(fontSize: 20.0,color: Colors.blue),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].totalDeaths.toString(),
                                          style: TextStyle(fontSize: 20.0,color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "New Cases",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "Total Cases",
                                          style: TextStyle(fontSize: 15.0),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "Total Deaths",
                                          style: TextStyle(fontSize: 15.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].newDeaths.toString(),
                                          style: TextStyle(fontSize: 20.0,color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].activeCases.toString(),
                                          style: TextStyle(fontSize: 20.0,color: Colors.lightBlue),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].totalRecovered.toString(),
                                          style: TextStyle(fontSize: 20.0,color: Colors.cyan),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "New Deaths",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "Active Cases",
                                          style: TextStyle(fontSize: 15.0),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "Total Recovered",
                                          style: TextStyle(fontSize: 15.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
