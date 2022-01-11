class DragonModel {
  final String id;
  final String description;
  final String name;
  final List<String> flickr_images;
  final String launch_date_utc;
  final num dry_mass_kg;

  DragonModel({
    required this.id,
    required this.description,
    required this.name,
    required this.flickr_images,
    required this.launch_date_utc,
    required this.dry_mass_kg,
  });

  factory DragonModel.jsonParse(Map<String, dynamic> json) {
    List<String> _convertList(List<dynamic> list) {
      return list.map((e) => e as String).toList();
    }

    return DragonModel(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      flickr_images: _convertList(json['flickr_images']),
      launch_date_utc: json['first_flight'],
      dry_mass_kg: json['dry_mass_kg'],
    );
  }
}
