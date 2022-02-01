// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures, unnecessary_new

import 'package:flutter/material.dart';
import 'package:tweet_wtf/Widgets/data_table.dart';
import 'package:tweet_wtf/Widgets/post_list.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildPostCard(Masjid post) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(post.name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          MyTimer(id: post.id),
          MyTable(
            id: post.id,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                launch(
                    'https://www.google.com/maps/place/Masjid+At-Taqwa/@33.919032,-84.278033,15z/data=!4m5!3m4!1s0x0:0x41a0d3955509681d!8m2!3d33.919032!4d-84.278033');
              },
              child: Text('Directions'),
            ),
          )
        ],
      ),
    ),
  );
}
