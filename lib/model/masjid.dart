// ignore_for_file: unnecessary_new

class Masjid {
  final String name;
  final String id;

  Masjid._({required this.name, required this.id});

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return new Masjid._(
      name: json['name'],
      id: json['id'],
    );
  }
}
