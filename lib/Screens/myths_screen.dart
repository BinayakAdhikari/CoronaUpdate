import 'dart:convert';

import 'package:coronaupdate/Models/corona_myths_model.dart';
import 'package:coronaupdate/Utils/browser_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<CoronaMythsModel>> _fetchMyths() async {
  String apiEndpoint = "https://nepalcorona.info/api/v1";
  String route = "$apiEndpoint/myths";
  http.Response response = await http.get(route, headers: {
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> news = data['data'];
    List<CoronaMythsModel> newsList = List();
    newsList =
        (news).map((data) => new CoronaMythsModel.fromJson(data)).toList();
    return newsList;
  } else {
    throw Exception('Failed to bust Myths');
  }
}

class MythsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MythsScreenState();
  }
}

class MythsScreenState extends State<MythsScreen> {
  Future<List<CoronaMythsModel>> mythLists;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mythLists = _fetchMyths();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Corona Myths'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return _fetchMyths().then((value) {
            setState(() {
              mythLists = _fetchMyths();
            });
          });
        },
        child: FutureBuilder(
          future: mythLists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        BrowserUtil.openBrowser(snapshot.data[index].sourceUrl);
                      },
                      child: Card(
                        margin: EdgeInsets.all(3.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.40,
                              child: Image(
                                fit: BoxFit.fill,
                                image:
                                NetworkImage(snapshot.data[index].imageUrl),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${snapshot.data[index].myth}',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Source : ${snapshot.data[index].sourceName}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
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
