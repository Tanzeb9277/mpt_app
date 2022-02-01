import 'package:flutter/material.dart';
import 'package:tweet_wtf/model/masjid.dart';
import '../Widgets/post_card.dart';

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:tweet_wtf/Widgets/post_card.dart';
import 'post.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<List<Masjid>> fetchMasjids(http.Client client) async {
  final response = await client.get(Uri.parse(
      'https://us-central1-cogent-tine-336309.cloudfunctions.net/mosque_get'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseMasjids, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Masjid> parseMasjids(String responseBody) {
  final parsed =
      jsonDecode(responseBody)['mosques'].cast<Map<String, dynamic>>();

  return parsed.map<Masjid>((json) => Masjid.fromJson(json)).toList();
}

class Masjid {
  final String id;
  final String name;

  const Masjid({
    required this.id,
    required this.name,
  });

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(id: json['id'], name: json['name']);
  }
}

class MasjidList extends StatelessWidget {
  const MasjidList({Key? key, required this.masjids}) : super(key: key);

  final List<Masjid> masjids;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: masjids.length,
      padding: EdgeInsets.all(15),
      itemBuilder: (BuildContext _context, int i) {
        return buildPostCard(masjids[i]);
      },
    ));
  }
}

/*class PostList extends StatelessWidget {
  PostList() : super();

  final posts = getPosts();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: posts.length,
      padding: EdgeInsets.all(15),
      itemBuilder: (BuildContext _context, int i) {
        return buildPostCard(posts[i]);
      },
    ));
  }
}**/
