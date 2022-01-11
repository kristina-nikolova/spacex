import '../models/company_model.dart';
import '../models/core_model.dart';
import '../models/dragon_model.dart';
import '../models/launch_model.dart';
import '../models/launchpad_model.dart';
import '../models/roadster_model.dart';
import '../models/rocket_model.dart';
import '../models/ship_model.dart';

abstract class SpaceXService {
  Future<List<LaunchModel>> getAllLaunches();
  Future<LaunchModel> getNextLaunch();
  Future<List<LaunchModel>> getUpcommingLaunches();
  Future<List<LaunchModel>> getPastLaunches();
  Future<LaunchModel> getLaunchDetails(String id);
  Future<LaunchpadModel> getLaunchpad(String? id);
  Future<RocketModel> getRocketDetails(String id);
  Future<RoadsterModel> getRoadsterDetails();
  Future<ShipModel> getShipDetails(String? id);
  Future<DragonModel> getDragonDetails(String? id);
  Future<CompanyModel> getCompany();
  Future<CoreModel> getCore(String coreId);
  Future<List<dynamic>> getVehicles();
}
