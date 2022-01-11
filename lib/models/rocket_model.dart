class RocketModel {
  final String id;
  final String description;
  final String name;
  final List<String> flickr_images;
  final MassModel mass;
  final String launch_date_utc;

  RocketModel({
    required this.id,
    required this.description,
    required this.name,
    required this.flickr_images,
    required this.mass,
    required this.launch_date_utc,
  });

  factory RocketModel.jsonParse(Map<String, dynamic> json) {
    List<String> _convertList(List<dynamic> list) {
      return list.map((e) => e as String).toList();
    }

    return RocketModel(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      flickr_images: _convertList(json['flickr_images']),
      mass: MassModel.jsonParse(json['mass']),
      launch_date_utc: json['first_flight'],
    );
  }
}

class MassModel {
  num kg;
  num lb;

  MassModel({required this.kg, required this.lb});

  factory MassModel.jsonParse(Map<String, dynamic> json) {
    return MassModel(kg: json['kg'], lb: json['lb']);
  }
}
