import 'package:flutter/foundation.dart';

class VehicleProvider extends ChangeNotifier {
  int _vehicleCount = 0;

  int get vehicleCount => _vehicleCount;

  void setVehicleCount(int count) {
    _vehicleCount = count;
    notifyListeners();
  }

  void incrementVehicleCount() {
    _vehicleCount++;
    notifyListeners();
  }

  void decrementVehicleCount() {
    if (_vehicleCount > 0) {
      _vehicleCount--;
      notifyListeners();
    }
  }
} 