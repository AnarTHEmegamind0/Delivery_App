import '../models/driver_profile_model.dart';

class DriverRepository {
  // Mock data for now
  Future<DriverProfileModel> fetchDriverProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return DriverProfileModel(
      id: '1',
      name: 'Д. Дорж',
      phone: '+97699111234',
      rating: 4.8,
      totalReviews: 247,
      totalDeliveries: 156,
      vehicleNumber: 'УБ 1234 АА',
      vehicleType: 'Машины дугаар',
      isOnline: false,
    );
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make API call
  }

  Future<void> updateProfile(DriverProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, would make API call
  }

  Future<void> uploadDocument(String documentType, String filePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, would upload document
  }
}
