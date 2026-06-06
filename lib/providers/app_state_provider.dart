import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../models/parcel_model.dart';
import '../models/food_choice_model.dart';

class AppStateProvider extends ChangeNotifier {
  // Navigation Drawer Selection
  String _currentScreen = 'Dashboard';
  String get currentScreen => _currentScreen;

  void changeScreen(String screenName) {
    _currentScreen = screenName;
    notifyListeners();
  }

  // Profile Details
  String name = 'VASANTH PRASATH S';
  String registerNumber = '21CSR012';
  String department = 'Computer Science & Engineering';
  String year = 'III Year';
  String hostelBlock = 'CV Raman Block (C-Block)';
  String roomNumber = '304';
  String phoneNumber = '+91 98765 43210';
  String email = 'vasanth.prasath.s@meicollege.edu';
  String password = 'password123';

  // Requests Data
  final List<PermissionRequest> _requests = [
    PermissionRequest(
      id: 'REQ001',
      requestType: 'Symposium',
      fromDate: DateTime.now().subtract(const Duration(days: 10)),
      toDate: DateTime.now().subtract(const Duration(days: 9)),
      timeOut: '08:00 AM',
      timeIn: '06:00 PM',
      createdDate: DateTime.now().subtract(const Duration(days: 12)),
      reason: 'Attending national level technical symposium at IIT Madras.',
      status: RequestStatus.approved,
    ),
    PermissionRequest(
      id: 'REQ002',
      requestType: 'Holiday',
      fromDate: DateTime.now().add(const Duration(days: 2)),
      toDate: DateTime.now().add(const Duration(days: 5)),
      timeOut: '04:00 PM',
      timeIn: '08:00 AM',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      reason: 'Going home for Diwali celebration with family.',
      status: RequestStatus.pending,
    ),
    PermissionRequest(
      id: 'REQ003',
      requestType: 'Leave',
      fromDate: DateTime.now().subtract(const Duration(days: 20)),
      toDate: DateTime.now().subtract(const Duration(days: 20)),
      timeOut: '09:00 AM',
      timeIn: '05:00 PM',
      createdDate: DateTime.now().subtract(const Duration(days: 21)),
      reason: 'Urgent dental checkup at clinic.',
      status: RequestStatus.rejected,
    ),
  ];

  List<PermissionRequest> get requests => List.unmodifiable(_requests);

  void addRequest(PermissionRequest request) {
    _requests.insert(0, request);
    notifyListeners();
  }

  // Food Choice Data
  final Map<String, FoodChoiceModel> _foodChoices = {
    // Key is date formatted as YYYY-MM-DD
  };

  FoodChoiceModel getFoodChoiceForDate(DateTime date) {
    final key = _formatDateKey(date);
    if (!_foodChoices.containsKey(key)) {
      _foodChoices[key] = FoodChoiceModel(
        date: date,
        breakfast: MealType.veg,
        lunch: MealType.veg,
        dinner: MealType.veg,
      );
    }
    return _foodChoices[key]!;
  }

  void updateFoodChoice(DateTime date, {MealType? breakfast, MealType? lunch, MealType? dinner}) {
    final key = _formatDateKey(date);
    final current = getFoodChoiceForDate(date);
    _foodChoices[key] = FoodChoiceModel(
      date: date,
      breakfast: breakfast ?? current.breakfast,
      lunch: lunch ?? current.lunch,
      dinner: dinner ?? current.dinner,
    );
    notifyListeners();
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Parcel Tracking Data
  final List<ParcelModel> _parcels = [
    ParcelModel(
      id: 'PRC001',
      trackingNumber: 'TRACK987654321',
      courierService: 'Amazon Delivery',
      receivedDate: DateTime.now().subtract(const Duration(days: 1)),
      status: ParcelStatus.received,
      recipientName: 'VASANTH PRASATH S',
    ),
    ParcelModel(
      id: 'PRC002',
      trackingNumber: 'TRACK554433221',
      courierService: 'BlueDart Express',
      receivedDate: DateTime.now().subtract(const Duration(days: 3)),
      status: ParcelStatus.delivered,
      recipientName: 'VASANTH PRASATH S',
    ),
  ];

  List<ParcelModel> get parcels => List.unmodifiable(_parcels);

  void addScannedParcel(String trackingNumber, String courier) {
    _parcels.insert(
      0,
      ParcelModel(
        id: 'PRC${DateTime.now().millisecondsSinceEpoch}',
        trackingNumber: trackingNumber,
        courierService: courier,
        receivedDate: DateTime.now(),
        status: ParcelStatus.received,
        recipientName: name,
      ),
    );
    notifyListeners();
  }

  // Emergency Requests Data
  final List<Map<String, dynamic>> _emergencies = [];
  List<Map<String, dynamic>> get emergencies => List.unmodifiable(_emergencies);

  void submitEmergency(String type, String description, String contact, String? proofPath) {
    _emergencies.insert(0, {
      'id': 'EMG${DateTime.now().millisecondsSinceEpoch}',
      'type': type,
      'description': description,
      'contact': contact,
      'proofPath': proofPath,
      'date': DateTime.now(),
      'status': 'Submitted',
    });
    notifyListeners();
  }

  // Password Update
  bool updatePassword(String currentPass, String newPass) {
    if (currentPass == password) {
      password = newPass;
      notifyListeners();
      return true;
    }
    return false;
  }
}
