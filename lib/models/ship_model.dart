class ShipModel {
  final String id;
  final String name;
  final num mass_kg;
  final num speed_kn;
  final dynamic image;
  final dynamic description;

  ShipModel(
      {required this.id,
      required this.name,
      required this.mass_kg,
      required this.speed_kn,
      required this.image,
      this.description});

  factory ShipModel.jsonParse(Map<String, dynamic> json) {
    return ShipModel(
        id: json['id'],
        name: json['name'],
        mass_kg: json['mass_kg'],
        speed_kn: json['speed_kn'],
        image: json['image'],
        description: json['description']);
  }
}
