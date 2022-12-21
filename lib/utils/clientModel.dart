// ignore_for_file: file_names

class Client {
  String id;
  final String nomClt;
  final String representant;
  final String telephone;
  final double latitude;
  final double longitude;

  Client({
    this.id = '',
    required this.nomClt,
    required this.representant,
    required this.telephone,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nomClt': nomClt,
        'representant': representant,
        'telephone': telephone,
        'latitude': latitude,
        'longitude': longitude,
      };

  static Client fromJson(Map<String, dynamic> json) => Client(
        nomClt: json['nomClt'],
        representant: json['representant'],
        telephone: json['telephone'],
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
