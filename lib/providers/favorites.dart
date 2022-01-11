import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:spacex/models/vehicle_model.dart';

class FavoritesProvider with ChangeNotifier {
  FavoritesProvider();

  List<VehicleModel> _favVehicles = [];

  List<VehicleModel> get favVehicles {
    return _favVehicles;
  }

  void addToFavVehicles(VehicleModel vehicle) {
    _favVehicles.add(vehicle);
    notifyListeners();
  }

  void removeFromFavVehicles(String id) {
    _favVehicles.removeWhere((vehicle) => vehicle.id == id);
    notifyListeners();
  }

  void updateFavVehicles(List<VehicleModel> vehicles) {
    _favVehicles = vehicles;
    notifyListeners();
  }

  bool isFavorite(String id) {
    dynamic foundVehicle;
    foundVehicle = _favVehicles.firstWhereOrNull((vehicle) => vehicle.id == id);

    if (foundVehicle != null) {
      return true;
    } else {
      return false;
    }
  }
}
