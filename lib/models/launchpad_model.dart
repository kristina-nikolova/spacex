class LaunchpadModel {
  final String id;
  final String name;
  final String full_name;
  final String locality;
  final String region;
  final num latitude;
  final num longitude;
  final List<String> launches;

  LaunchpadModel({
    required this.id,
    required this.name,
    required this.full_name,
    required this.locality,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.launches,
  });

  factory LaunchpadModel.jsonParse(Map<String, dynamic> json) {
    List<String> _convertList(List<dynamic> list) {
      return list.map((e) => e as String).toList();
    }

    return LaunchpadModel(
      id: json['id'],
      name: json['name'],
      full_name: json['full_name'],
      locality: json['locality'],
      region: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      launches: _convertList(json['launches']),
    );
  }
}
