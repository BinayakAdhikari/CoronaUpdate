import 'dart:convert';

import 'package:coronaupdate/Models/corona_news_model.dart';
import 'package:coronaupdate/Utils/browser_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<CoronaNewsModel>> _fetchNews() async {
  String apiEndpoint = "https://nepalcorona.info/api/v1";
  String route = "$apiEndpoint/news";
  http.Response response = await http.get(route, headers: {
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> news = data['data'];
    List<CoronaNewsModel> newsList = List();
    newsList =
        (news).map((data) => new CoronaNewsModel.fromJson(data)).toList();
    return newsList;
  } else {
    throw Exception('Failed to load News');
  }
}

class NewsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsScreenState();
  }
}

class NewsScreenState extends State<NewsScreen> {
  Future<List<CoronaNewsModel>> newsLists;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsLists = _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Corona News'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return _fetchNews().then((value) {
            setState(() {
              newsLists = _fetchNews();
            });
          });
        },
        child: FutureBuilder(
          future: newsLists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        BrowserUtil.openBrowser(snapshot.data[index].url);
                      },
                      child: Card(
                        margin: EdgeInsets.all(3.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: Image(
                                fit: BoxFit.fill,
                                image:
                                    NetworkImage(snapshot.data[index].imageUrl),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('      ${snapshot.data[index].title}',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '       ${snapshot.data[index].summary}',
                                style: TextStyle(
                                    fontSize: 15, fontStyle: FontStyle.italic),
                                maxLines: 3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Source : ${snapshot.data[index].source}',
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
