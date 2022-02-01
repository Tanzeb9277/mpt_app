import 'dart:convert';
import 'package:http/http.dart' as http;

class MasjidData{
  Future<Welcome> fetchAlbum() async {
  var masjidData = null;
  final response = await http.get(Uri.parse(
      'https://us-central1-cogent-tine-336309.cloudfunctions.net/mosque_get'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var masjids = json.decode(response.body);
    masjidData = Welcome.fromJson(masjids);

    return masjidData;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
}

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.mosques,
  });

  List<Mosque> mosques;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        mosques:
            List<Mosque>.from(json["mosques"].map((x) => Mosque.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mosques": List<dynamic>.from(mosques.map((x) => x.toJson())),
      };
}

class Mosque {
  Mosque({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Mosque.fromJson(Map<String, dynamic> json) => Mosque(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
