import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final String url = "https://api.covid19india.org/data.json";
  final String _url =
      "https://api.covid19india.org/v2/state_district_wise.json";
  List<dynamic> data;
  List<dynamic> _data;
  List<dynamic> _dist;
  List<dynamic> _dist2 = List<dynamic>();

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var _response = await http
        .get(Uri.encodeFull(_url), headers: {"Accept": "application/json"});

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      var toJsonData = json.decode(response.body);
      var _toJsonData = json.decode(_response.body);
      data = toJsonData['statewise'];

      _dist = _toJsonData;
      _data = data.sublist(1, data.length);

      for (int i = 0; i < _data.length; i++) {
        for (int j = 0; j < _dist.length; j++) {
          if (_data[i]['state'] == _dist[j]['state']) {
            _dist2.add(_dist[j]);
            break;
          } else {
            if (j >= _dist.length - 1)
              _dist2.add({
                "state": _data[i]['state'],
                "districtData": [
                  {
                    "district": "Unknown",
                    "confirmed": "Unknown",
                  }
                ]
              });
          }
        }
      }
      _data.add(data[0]);
      // print(_data[0]['state']);
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(
                  "images/virus.png",
                  height: 30.0,
                  width: 30.0,
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 25, fontFamily: 'Montserrat'),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'CORONA',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.blue,
            tabs: [
              Tab(
                child: Container(
                    alignment: Alignment.center,
                    child:
                        Text("STATE", style: (TextStyle(color: Colors.black)))),
              ),
              Tab(
                child: Container(
                    alignment: Alignment.center,
                    child: Text("DISTRICT",
                        style: (TextStyle(color: Colors.black)))),
              ),
              Tab(
                child: Container(
                    alignment: Alignment.center,
                    child:
                        Text("INFO", style: (TextStyle(color: Colors.black)))),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: new Card(
                        child: new Container(
                      child: Container(
                          child: new Text(
                        "STATE",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 10, 2, 10),
                    )),
                  ),
                  Expanded(
                    child: new Card(
                        child: new Container(
                      child: Center(
                          child: new Text(
                        "CONFIRMED",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 10, 2, 10),
                    )),
                  ),
                  Expanded(
                    child: new Card(
                        child: new Container(
                      child: Center(
                          child: new Text(
                        "ACTIVE",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 10, 2, 10),
                    )),
                  ),
                  Expanded(
                    child: new Card(
                        child: new Container(
                      child: Center(
                          child: new Text(
                        "RECOVERED",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 10, 2, 10),
                    )),
                  ),
                  Expanded(
                    child: new Card(
                        child: new Container(
                      child: Center(
                          child: new Text(
                        "DECEASED",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 10, 2, 10),
                    )),
                  )
                ]),
                Expanded(
                  child: RefreshIndicator(
                    child: new ListView.builder(
                        itemCount: _data == null ? 0 : _data.length - 1,
                        itemBuilder: (BuildContext context, int index) {
                          return new Container(
                              child: new Center(
                                  child: Row(
                            children: <Widget>[
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Card(
                                        child: new Container(
                                      child: Container(
                                          child: new Text(
                                        _data[index]['state'].toString(),
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 2, 10),
                                    ))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Card(
                                        color: Colors.red.shade100,
                                        child: new Container(
                                          child: Center(
                                              child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: _data[index]
                                                              ['deltaconfirmed']
                                                          .toString() +
                                                      '↑ ',
                                                  style: TextStyle(
                                                      fontSize: 11.5,
                                                      color: Colors.red),
                                                ),
                                                TextSpan(
                                                  text: _data[index]
                                                          ['confirmed']
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          )),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 5, 10),
                                        ))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Card(
                                        color: Colors.blue.shade100,
                                        child: new Container(
                                          child: Center(
                                            child: new Text(
                                              _data[index]['active'].toString(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                        ))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Card(
                                        color: Colors.green.shade100,
                                        child: new Container(
                                          child: Center(
                                            child: new Text(
                                              _data[index]['recovered']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 5, 10),
                                        ))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Card(
                                        color: Colors.grey.shade100,
                                        child: new Container(
                                          child: Center(
                                            child: new Text(
                                              _data[index]['deaths'].toString(),
                                              style: TextStyle(
                                                  //
                                                  color: Colors.black),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 5, 10),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          )));
                        }),
                    onRefresh: getJsonData,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: _data == null ? 0 : 1,
                          itemBuilder: (BuildContext context, int index) {
                            return new Container(
                                child: new Center(
                                    child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      new Card(
                                          child: new Container(
                                        child: Container(
                                            child: new Text(
                                          _data[_data.length - 1]['state']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 2, 10),
                                      ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      new Card(
                                          child: new Container(
                                        child: Center(
                                          child: new Text(
                                            _data[_data.length - 1]['confirmed']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 10, 5, 10),
                                      ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      new Card(
                                          child: new Container(
                                        child: Center(
                                          child: new Text(
                                            _data[_data.length - 1]['active']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                      ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      new Card(
                                          child: new Container(
                                        child: Center(
                                          child: new Text(
                                            _data[_data.length - 1]['recovered']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 10, 5, 10),
                                      ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      new Card(
                                          child: new Container(
                                        child: Center(
                                          child: new Text(
                                            _data[_data.length - 1]['deaths']
                                                .toString(),
                                            style: TextStyle(
                                                //
                                                color: Colors.black),
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 10, 5, 10),
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                            )));
                          }),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: new Card(
                        child: new Container(
                      child: Center(
                          child: new Text(
                        "DISTRICT",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 30, 2, 30),
                    )),
                  ),
                  Expanded(
                    child: new Card(
                        child: new Container(
                      child: Center(
                          child: new Text(
                        "CONFIRMED",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 30, 2, 30),
                    )),
                  ),
                ]),
                Expanded(
                  child: RefreshIndicator(
                    child: new ListView.builder(
                        itemCount: _data == null ? 0 : _data.length - 1,
                        itemBuilder: (BuildContext context, int index) {
                          return new Container(
                              child: new Center(
                                  child: Row(
                            children: <Widget>[
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Card(
                                        child: new Container(
                                      child: ExpansionTile(
                                        title: new Text(
                                          _data[index]['state'].toString(),
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        children: <Widget>[
                                          new ListView.builder(
                                              physics: ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: _data == null
                                                  ? 0
                                                  : _dist2[index]
                                                          ['districtData']
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int _index) =>
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: new Card(
                                                                color: Colors
                                                                    .white,
                                                                child:
                                                                    new Container(
                                                                  child: Center(
                                                                    child:
                                                                        new Text(
                                                                      _dist2[index]['districtData'][_index]
                                                                              [
                                                                              'district']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          5,
                                                                          10,
                                                                          5,
                                                                          10),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            child: new Card(
                                                                color: Colors
                                                                    .red
                                                                    .shade100,
                                                                child:
                                                                    new Container(
                                                                  child: Center(
                                                                      child:
                                                                          RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      style:
                                                                          TextStyle(),
                                                                      children: <
                                                                          TextSpan>[
                                                                        TextSpan(
                                                                          text: _dist2[index]['districtData'][_index]['delta']['confirmed'].toString() +
                                                                              '↑ ',
                                                                          style: TextStyle(
                                                                              fontSize: 11.5,
                                                                              color: Colors.red),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              _dist2[index]['districtData'][_index]['confirmed'].toString(),
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          5,
                                                                          10,
                                                                          5,
                                                                          10),
                                                                )),
                                                          )
                                                        ],
                                                      )),
                                        ],
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 2, 10),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          )));
                        }),
                    onRefresh: getJsonData,
                  ),
                ),
              ],
            ),
            Container(
                child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 0, 10),
                        child: Text(
                          'OVERVIEW',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Coronavirus disease (COVID-19) is an infectious disease caused by a new virus.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n\n"),
                            TextSpan(
                              text:
                                  'The disease causes respiratory illness (like the flu) with symptoms such as a cough, fever, and in more severe cases, difficulty breathing. You can protect yourself by washing your hands frequently, avoiding touching your face, and avoiding close contact (1 meter or 3 feet) with people who are unwell.\n',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'How it spreads',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n\n"),
                            TextSpan(
                              text:
                                  'Coronavirus disease spreads primarily through contact with an infected person when they cough or sneeze. It also spreads when a person touches a surface or object that has the virus on it, then touches their eyes, nose, or mouth.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 0, 10),
                        child: Text(
                          'SYMPTOMS',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'People may be sick with the virus for 1 to 14 days before developing symptoms. The most common symptoms of coronavirus disease (COVID-19) are fever, tiredness, and dry cough. Most people (about 80%) recover from the disease without needing special treatment.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n\n"),
                            TextSpan(
                              text:
                                  'More rarely, the disease can be serious and even fatal. Older people, and people with other medical conditions (such as asthma, diabetes, or heart disease), may be more vulnerable to becoming severely ill.\n',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'People may experience:',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n\n"),
                            TextSpan(
                              text: '• cough \n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: '• fever \n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: '• tiredness \n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: '• difficulty breathing (severe cases)',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 0, 10),
                        child: Text(
                          'PREVENTION',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'There’s currently no vaccine to prevent coronavirus disease (COVID-19)',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n"),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'You can protect yourself and help prevent spreading the virus to others if you:',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n\n"),
                            TextSpan(
                              text: 'Do\n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text:
                                  '• Wash your hands regularly for 20 seconds, with soap and water or alcohol-based hand rub \n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text:
                                  '• Cover your nose and mouth with a disposable tissue or flexed elbow when you cough or sneeze \n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text:
                                  '• Avoid close contact (1 meter or 3 feet) with people who are unwell \n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text:
                                  '• Stay home and self-isolate from others in the household if you feel unwell \n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: "Don't \n",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text:
                                  '• Touch your eyes, nose, or mouth if your hands are not clean',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 0, 10),
                        child: Text(
                          'TREATMENT',
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'There is no specific medicine to prevent or treat coronavirus disease (COVID-19). People may need supportive care to help them breathe.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n"),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'If you develop a fever, cough, and have difficulty breathing, promptly seek medical care. Call in advance and tell your health provider of any recent travel or recent contact with travelers.',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(text: "\n\n"),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ))
          ],
        ),
      ),
    );
  }
}
