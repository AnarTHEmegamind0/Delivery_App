import 'package:flutter/foundation.dart';
import '../models/driver_profile_model.dart';
import '../repositories/driver_repository.dart';

class DriverProvider with ChangeNotifier {
  final DriverRepository _repository = DriverRepository();
  
  DriverProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  DriverProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _profile?.isOnline ?? false;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _repository.fetchDriverProfile();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleOnlineStatus() async {
    if (_profile == null) return;

    final newStatus = !_profile!.isOnline;
    
    try {
      await _repository.updateOnlineStatus(newStatus);
      _profile = _profile!.copyWith(isOnline: newStatus);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProfile(DriverProfileModel profile) async {
    try {
      await _repository.updateProfile(profile);
      _profile = profile;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
