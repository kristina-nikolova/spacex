import 'package:flutter/material.dart';

import '../models/launchpad_model.dart';
import '../services/get_data_service.dart';

class LaunchpadProvider with ChangeNotifier {
  LaunchpadModel? _launchpad;

  LaunchpadModel? get launchpad {
    return _launchpad;
  }

  Future<LaunchpadModel> getLaunchpad(String? launchpadId) async {
    final GetDataService api = GetDataService();
    LaunchpadModel response = await api.getLaunchpad(launchpadId);

    _launchpad = response;
    notifyListeners();

    return response;
  }
}
