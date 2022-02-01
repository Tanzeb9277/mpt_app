// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, no_logic_in_create_state, prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Album> fetchAlbum(String id) async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd').format(now);
  final response = await http.get(Uri.parse(
      'https://us-central1-cogent-tine-336309.cloudfunctions.net/prayer_get?mosqueId=' +
          id +
          '&day=2021-' +
          formattedDate));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String fajr_st,
      fajr_iq,
      zuhr_st,
      zuhr_iq,
      asr_st,
      asr_iq,
      magrib_st,
      magrib_iq,
      isha_st,
      isha_iq;

  Album(
      {required this.fajr_st,
      required this.fajr_iq,
      required this.zuhr_st,
      required this.zuhr_iq,
      required this.asr_st,
      required this.asr_iq,
      required this.magrib_st,
      required this.magrib_iq,
      required this.isha_st,
      required this.isha_iq});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      fajr_st: json['fajr_start'],
      fajr_iq: json['fajr_iqama'],
      zuhr_st: json['zuhr_start'],
      zuhr_iq: json['zuhr_iqama'],
      asr_st: json['asr_start'],
      asr_iq: json['asr_iqama'],
      magrib_st: json['magrib_start'],
      magrib_iq: json['magrib_iqama'],
      isha_st: json['isha_start'],
      isha_iq: json['isha_iqama'],
    );
  }
}

class MyTable extends StatefulWidget {
  final id;
  const MyTable({Key? key, required this.id}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(id: id);
}

TimeConverter(time) {
  DateFormat inputFormat = DateFormat('dd-MM-yyyy hh:mm:ss');
  DateTime input = inputFormat.parse(time);
  String datee = DateFormat('h:mm a').format(input);
  return datee;
}

DateFormater(String hrTime) {
  DateTime now = new DateTime.now();
  String date = DateFormat('yyyy-MM-dd').format(now);
  String convertedTime = TimeConverter(date + " " + hrTime);
  return convertedTime;
}

class _MyAppState extends State<MyTable> {
  var id;

  _MyAppState({this.id});

  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Album>(
      future: futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DataTable(
            columns: [
              DataColumn(
                  label: Text('Salat',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Start',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Iqama',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Fajr')),
                DataCell(Text(DateFormater(snapshot.data!.fajr_st))),
                DataCell(Text(DateFormater(snapshot.data!.fajr_iq))),
              ]),
              DataRow(cells: [
                DataCell(Text('Zuhur')),
                DataCell(Text(DateFormater(snapshot.data!.zuhr_st))),
                DataCell(Text(DateFormater(snapshot.data!.zuhr_iq))),
              ]),
              DataRow(cells: [
                DataCell(Text('Asr')),
                DataCell(Text(DateFormater(snapshot.data!.asr_st))),
                DataCell(Text(DateFormater(snapshot.data!.asr_iq))),
              ]),
              DataRow(cells: [
                DataCell(Text('Magrib')),
                DataCell(Text("")),
                DataCell(Text(DateFormater(snapshot.data!.magrib_iq))),
              ]),
              DataRow(cells: [
                DataCell(Text('Isha')),
                DataCell(Text(DateFormater(snapshot.data!.isha_st))),
                DataCell(Text(DateFormater(snapshot.data!.isha_iq))),
              ]),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

TimeDifferance(String time) {
  DateTime now = new DateTime.now();
  var formated = DateFormat("HH:mm:ss");
  String current = DateFormat('HH:mm:ss').format(now);
  var one = formated.parse(current);
  var two = formated.parse(time);
  if (one.isAfter(two)) {
    String difference = '${two.difference(one)}';
    var splitTime = difference.split(':');
    var hr = int.parse(splitTime[0]);
    var min = int.parse(splitTime[1]);
    var addmin = (60 - min).toString();
    var addhr = (hr + 24).toString();
    if (addhr == "00") {
      var addedTime = (addmin + ' mins');
      return (addedTime);
    } else {
      var addedTime = (addhr + ' Hrs ' + addmin + ' mins');
      return (addedTime);
    }
  } else {
    String difference = '${two.difference(one)}';
    DateFormat df = DateFormat('HH:mm:ss');
    DateTime dt = df.parse(difference);
    String string = DateFormat.Hm().format(dt);
    var splitTime = string.split(':');

    if (splitTime[0] == "00") {
      var addedTime = (splitTime[1] + ' mins');
      return (addedTime);
    } else {
      var addedTime = (splitTime[0] + ' Hrs ' + splitTime[1] + ' mins');
      return (addedTime);
    }
  }
}

class MyTimer extends StatefulWidget {
  final id;
  const MyTimer({Key? key, required this.id}) : super(key: key);
  @override
  _MyTimerState createState() => _MyTimerState(id: id);
}

class _MyTimerState extends State<MyTimer> {
  var id;

  _MyTimerState({this.id});
  late var _now;
  late Timer _everySecond;

  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(id);

    _now = FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          var formated = DateFormat("HH:mm");

          var salats = [
            snapshot.data!.fajr_iq,
            snapshot.data!.zuhr_iq,
            snapshot.data!.asr_iq,
            snapshot.data!.magrib_iq,
            snapshot.data!.isha_iq,
          ];

          var salatNames = ["Fajr", "Zuhr", "Asr", "Magrib", "Isha"];

          NearestTime() {
            final dateTimes = <DateTime>[
              formated.parse(snapshot.data!.fajr_iq),
              formated.parse(snapshot.data!.zuhr_iq),
              formated.parse(snapshot.data!.asr_iq),
              formated.parse(snapshot.data!.magrib_iq),
              formated.parse(snapshot.data!.isha_iq),
            ];
            DateTime now = new DateTime.now();
            var current = DateFormat('HH:mm').format(now);
            var currentTime = formated.parse(current);

            if (currentTime.isAfter(dateTimes[4])) {
              return 0;
            } else {
              final closetsDateTimeToNow = dateTimes.reduce((a, b) =>
                  a.difference(currentTime).abs() <
                          b.difference(currentTime).abs()
                      ? a
                      : b);

              var SalatNum = dateTimes.indexOf(closetsDateTimeToNow);

              return (SalatNum);
            }
          }

          var num = NearestTime();

          String timeleft = TimeDifferance(salats[num]);
          return Text(timeleft + " Til " + salatNames[num],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
        });

    _everySecond = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => {
              if (mounted)
                setState(() {
                  _now = FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        var formated = DateFormat("HH:mm");

                        var salats = [
                          snapshot.data!.fajr_iq,
                          snapshot.data!.zuhr_iq,
                          snapshot.data!.asr_iq,
                          snapshot.data!.magrib_iq,
                          snapshot.data!.isha_iq,
                        ];

                        var salatNames = [
                          "Fajr",
                          "Zuhr",
                          "Asr",
                          "Magrib",
                          "Isha"
                        ];

                        NearestTime() {
                          final dateTimes = <DateTime>[
                            formated.parse(snapshot.data!.fajr_iq),
                            formated.parse(snapshot.data!.zuhr_iq),
                            formated.parse(snapshot.data!.asr_iq),
                            formated.parse(snapshot.data!.magrib_iq),
                            formated.parse(snapshot.data!.isha_iq),
                          ];
                          DateTime now = new DateTime.now();
                          var current = DateFormat('HH:mm').format(now);
                          var currentTime = formated.parse(current);

                          if (currentTime.isAfter(dateTimes[4])) {
                            return 0;
                          } else {
                            final closetsDateTimeToNow = dateTimes.reduce(
                                (a, b) => a.difference(currentTime).abs() <
                                        b.difference(currentTime).abs()
                                    ? a
                                    : b);

                            var SalatNum =
                                dateTimes.indexOf(closetsDateTimeToNow);

                            return (SalatNum);
                          }
                        }

                        var num = NearestTime();

                        String timeleft = TimeDifferance(salats[num]);
                        return Text(timeleft + " Til " + salatNames[num],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold));
                      });
                })
            });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Album>(
      future: futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: _now,
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return Text('Timer');
      },
    );
  }
}
//timer = Timer.periodic(Duration(seconds: 1), rebuildUI(() {}));
//timer = Timer.periodic(Duration(seconds: 1), (timer) => rebuildUI(() {}));