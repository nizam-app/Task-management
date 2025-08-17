import 'package:flutter/foundation.dart';
import '../models/staff_model.dart';
import '../utils/mock_data.dart';

class StaffProvider extends ChangeNotifier {
  List<Staff> _staff = [];
  List<Credential> _credentials = [];
  bool _isLoading = false;
  String? _error;

  List<Staff> get staff => _staff;
  List<Staff> get activeStaff => _staff.where((s) => s.status == StaffStatus.active).toList();
  List<Staff> get inactiveStaff => _staff.where((s) => s.status == StaffStatus.inactive).toList();
  List<Credential> get credentials => _credentials;
  List<Credential> get expiringCredentials => _credentials.where((c) => c.daysUntilExpiry < 60 && c.daysUntilExpiry > 0).toList();
  List<Credential> get expiredCredentials => _credentials.where((c) => c.daysUntilExpiry <= 0).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  StaffProvider() {
    loadStaff();
    loadCredentials();
  }

  Future<void> loadStaff() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _staff = MockData.staff;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCredentials() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _credentials = MockData.credentials;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addCredential(String name, DateTime expiryDate) async {
    try {
      final newCredential = Credential(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        status: CredentialStatus.pending,
        expiryDate: expiryDate,
        uploadDate: DateTime.now(),
        verified: false,
      );
      
      _credentials.add(newCredential);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> approveCredential(String credentialId) async {
    try {
      final index = _credentials.indexWhere((c) => c.id == credentialId);
      if (index != -1) {
        // In a real app, this would update via API
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  double get credentialCompletionPercentage {
    if (_credentials.isEmpty) return 0.0;
    final verified = _credentials.where((c) => c.verified).length;
    return (verified / _credentials.length) * 100;
  }
}