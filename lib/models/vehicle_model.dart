import 'dart:convert';

class VehicleModel {
  final String id;
  final String name;
  List<dynamic>? flickr_images;
  String? image;
  String? first_flight;
  String? type;

  VehicleModel(
      {required this.id,
      required this.name,
      this.flickr_images,
      this.image,
      this.first_flight,
      this.type});

  factory VehicleModel.jsonParse(Map<String, dynamic> json) {
    return VehicleModel(
        id: json['id'],
        name: json['name'],
        flickr_images: json['flickr_images'],
        image: json['image'],
        first_flight: json['first_flight'],
        type: json['type']);
  }

  static Map<String, dynamic> toMap(VehicleModel vehicle) => {
        'id': vehicle.id,
        'name': vehicle.name,
        'flickr_images': vehicle.flickr_images,
        'image': vehicle.image,
        'first_flight': vehicle.first_flight,
        'type': vehicle.type,
      };

  static String encode(List<VehicleModel> vehicles) => json.encode(
        vehicles
            .map<Map<String, dynamic>>((vehicle) => VehicleModel.toMap(vehicle))
            .toList(),
      );

  static List<VehicleModel> decode(String vehicles) =>
      (json.decode(vehicles) as List<dynamic>)
          .map<VehicleModel>((item) => VehicleModel.jsonParse(item))
          .toList();
}
