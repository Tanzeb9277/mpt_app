// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_new

import 'package:flutter/material.dart';
import '../Widgets/post_list.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage() : super();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.lightBlue, title: Text('MPT')),
        body: FutureBuilder<List<Masjid>>(
            future: fetchMasjids(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [MasjidList(masjids: snapshot.data!)],
                    ),
                  ),
                ));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Container(
          color: Color(0xff258DED),
          height: 400.0,
          alignment: Alignment.center,
          child: new Column(
            children: [
              new Container(
                height: 200.0,
                width: 200.0,
                decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: new AssetImage('assets/logo.png'),
                        fit: BoxFit.fill),
                    shape: BoxShape.circle),
              ),
              new Container(
                child: new Text(
                  'Welcome to Prime Message',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Aleo',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
