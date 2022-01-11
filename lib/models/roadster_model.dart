class RoadsterModel {
  final String id;
  final String description;
  final String name;
  final List<String> flickr_images;
  final String launch_date_utc;
  final dynamic video;
  final num speed_mph;
  final num earth_distance_mi;
  final num mars_distance_km;
  final num launch_mass_kg;

  RoadsterModel(
      {required this.id,
      required this.description,
      required this.name,
      required this.flickr_images,
      this.video,
      required this.launch_date_utc,
      required this.speed_mph,
      required this.earth_distance_mi,
      required this.mars_distance_km,
      required this.launch_mass_kg});

  factory RoadsterModel.jsonParse(Map<String, dynamic> json) {
    List<String> _convertList(List<dynamic> list) {
      return list.map((e) => e as String).toList();
    }

    return RoadsterModel(
      id: json['id'],
      description: json['details'],
      name: json['name'],
      flickr_images: _convertList(json['flickr_images']),
      video: json['video'],
      launch_date_utc: json['launch_date_utc'],
      speed_mph: json['speed_mph'],
      earth_distance_mi: json['earth_distance_mi'],
      mars_distance_km: json['mars_distance_km'],
      launch_mass_kg: json['launch_mass_kg'],
    );
  }
}
