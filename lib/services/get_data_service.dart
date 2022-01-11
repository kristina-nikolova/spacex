import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/company_model.dart';
import '../models/core_model.dart';
import '../models/dragon_model.dart';
import '../models/launch_model.dart';
import '../models/launchpad_model.dart';
import '../models/roadster_model.dart';
import '../models/rocket_model.dart';
import '../models/ship_model.dart';
import '../models/vehicle_model.dart';
import 'spacex_service.dart';

class GetDataService extends SpaceXService {
  @override
  Future<List<LaunchModel>> getAllLaunches() async {
    const String uri = 'https://api.spacexdata.com/v4/launches';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);

    List<LaunchModel> list;
    list = (json.decode(data.body) as List)
        .map((data) => LaunchModel.jsonParse(data))
        .toList();

    return list;
  }

  @override
  Future<LaunchModel> getNextLaunch() async {
    const String uri = 'https://api.spacexdata.com/v4/launches/next';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return LaunchModel.jsonParse(json);
  }

  @override
  Future<List<LaunchModel>> getUpcommingLaunches() async {
    const String uri = 'https://api.spacexdata.com/v4/launches/upcoming';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);

    List<LaunchModel> list;
    list = (json.decode(data.body) as List)
        .map((data) => LaunchModel.jsonParse(data))
        .toList();

    return list;
  }

  @override
  Future<List<LaunchModel>> getPastLaunches() async {
    const String uri = 'https://api.spacexdata.com/v4/launches/past';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);

    List<LaunchModel> list;
    list = (json.decode(data.body) as List)
        .map((data) => LaunchModel.jsonParse(data))
        .toList();

    return list;
  }

  @override
  Future<LaunchModel> getLaunchDetails(String? id) async {
    String uri = 'https://api.spacexdata.com/v4/launches/$id';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return LaunchModel.jsonParse(json);
  }

  @override
  Future<LaunchpadModel> getLaunchpad(String? id) async {
    String uri = 'https://api.spacexdata.com/v4/launchpads/$id';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return LaunchpadModel.jsonParse(json);
  }

  @override
  Future<RocketModel> getRocketDetails(String? id) async {
    String uri = 'https://api.spacexdata.com/v4/rockets/$id';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return RocketModel.jsonParse(json);
  }

  @override
  Future<RoadsterModel> getRoadsterDetails() async {
    String uri = 'https://api.spacexdata.com/v4/roadster';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return RoadsterModel.jsonParse(json);
  }

  @override
  Future<ShipModel> getShipDetails(String? id) async {
    String uri = 'https://api.spacexdata.com/v4/ships/$id';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return ShipModel.jsonParse(json);
  }

  @override
  Future<DragonModel> getDragonDetails(String? id) async {
    String uri = 'https://api.spacexdata.com/v4/dragons/$id';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return DragonModel.jsonParse(json);
  }

  @override
  Future<CompanyModel> getCompany() async {
    String uri = 'https://api.spacexdata.com/v4/company';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return CompanyModel.jsonParse(json);
  }

  @override
  Future<CoreModel> getCore(String coreId) async {
    String uri = 'https://api.spacexdata.com/v4/cores/$coreId';
    final url = Uri.parse(uri);

    final http.Response data = await http.get(url);
    final Map<String, dynamic> json = jsonDecode(data.body);

    return CoreModel.jsonParse(json);
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    final rocketsUrl = Uri.parse('https://api.spacexdata.com/v4/rockets');
    final shipsUrl = Uri.parse('https://api.spacexdata.com/v4/ships');
    final dragonsUrl = Uri.parse('https://api.spacexdata.com/v4/dragons');
    final roadsterUrl = Uri.parse('https://api.spacexdata.com/v4/roadster');

    var responses = await Future.wait([
      http.get(rocketsUrl),
      http.get(shipsUrl),
      http.get(dragonsUrl),
      http.get(roadsterUrl),
    ]);

    return [
      ..._addTypeToVehicle(_getVehicleFromResponse(responses[0]), 'rocket'),
      ..._addTypeToVehicle(_getVehicleFromResponse(responses[1]), 'ship'),
      ..._addTypeToVehicle(_getVehicleFromResponse(responses[2]), 'dragon'),
      ..._addTypeToVehicle(_getVehicleFromResponse(responses[3]), 'roadster'),
    ];
  }

  _getVehicleFromResponse(http.Response response) {
    if (response.statusCode == 200) {
      if (json.decode(response.body) is List) {
        return [
          for (var item in json.decode(response.body))
            VehicleModel.jsonParse(item)
        ];
      } else {
        return [VehicleModel.jsonParse(json.decode(response.body))];
      }
    }
  }

  _addTypeToVehicle(List<VehicleModel> vehicles, String type) {
    for (var item in vehicles) {
      item.type = type;
    }
    return vehicles;
  }
}
