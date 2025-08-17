import 'package:flutter/foundation.dart';
import '../models/shift_model.dart';
import '../utils/mock_data.dart';

class ShiftProvider extends ChangeNotifier {
  List<Shift> _shifts = [];
  List<Shift> _myShifts = [];
  bool _isLoading = false;
  String? _error;

  List<Shift> get shifts => _shifts;
  List<Shift> get myShifts => _myShifts;
  List<Shift> get availableShifts => _shifts.where((s) => s.status == ShiftStatus.available).toList();
  List<Shift> get urgentShifts => _shifts.where((s) => s.urgency == ShiftUrgency.urgent).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  ShiftProvider() {
    loadShifts();
  }

  Future<void> loadShifts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      _shifts = MockData.shifts;
      _myShifts = _shifts.where((s) => s.assignedTo != null).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> claimShift(String shiftId) async {
    try {
      final shiftIndex = _shifts.indexWhere((s) => s.id == shiftId);
      if (shiftIndex != -1) {
        // Simulate claiming shift
        await Future.delayed(const Duration(milliseconds: 300));
        
        // In a real app, this would make an API call
        // For now, we'll just update the local state
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createShift(Map<String, dynamic> shiftData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newShift = Shift(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        facility: shiftData['facility'] ?? 'Mercy General Hospital',
        role: shiftData['role'] ?? '',
        department: shiftData['department'] ?? '',
        date: shiftData['date'] ?? DateTime.now(),
        startTime: shiftData['startTime'] ?? '09:00',
        endTime: shiftData['endTime'] ?? '17:00',
        payRate: shiftData['payRate'] ?? 0.0,
        status: ShiftStatus.available,
        urgency: shiftData['urgent'] == true ? ShiftUrgency.urgent : ShiftUrgency.normal,
        distance: 0.0,
        requirements: shiftData['requirements'] ?? <String>[],
        description: shiftData['description'] ?? '',
        benefits: shiftData['benefits'] ?? <String>[],
        facilityRating: 4.5,
      );
      
      _shifts.add(newShift);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterShifts(String query) {
    if (query.isEmpty) {
      loadShifts();
      return;
    }
    
    _shifts = _shifts.where((shift) =>
      shift.facility.toLowerCase().contains(query.toLowerCase()) ||
      shift.role.toLowerCase().contains(query.toLowerCase()) ||
      shift.department.toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    notifyListeners();
  }

  Map<String, int> get shiftStats {
    return {
      'total': _shifts.length,
      'available': availableShifts.length,
      'filled': _shifts.where((s) => s.status == ShiftStatus.filled).length,
      'urgent': urgentShifts.length,
    };
  }
}