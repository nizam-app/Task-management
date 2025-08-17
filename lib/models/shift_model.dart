enum ShiftStatus { available, filled, pending, cancelled }
enum ShiftUrgency { normal, urgent }

class Shift {
  final String id;
  final String facility;
  final String role;
  final String department;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double payRate;
  final ShiftStatus status;
  final ShiftUrgency urgency;
  final double distance;
  final int? matchScore;
  final List<String> requirements;
  final String description;
  final List<String> benefits;
  final double facilityRating;
  final String? shiftNotes;
  final String? assignedTo;
  final int applicants;

  Shift({
    required this.id,
    required this.facility,
    required this.role,
    required this.department,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.payRate,
    required this.status,
    this.urgency = ShiftUrgency.normal,
    required this.distance,
    this.matchScore,
    required this.requirements,
    required this.description,
    required this.benefits,
    required this.facilityRating,
    this.shiftNotes,
    this.assignedTo,
    this.applicants = 0,
  });

  String get timeRange => '$startTime - $endTime';
  
  double get totalPay {
    final hours = _calculateHours();
    return payRate * hours;
  }
  
  double _calculateHours() {
    final start = _timeStringToHours(startTime);
    final end = _timeStringToHours(endTime);
    return end > start ? end - start : (24 - start) + end;
  }
  
  double _timeStringToHours(String time) {
    final parts = time.split(':');
    return double.parse(parts[0]) + (double.parse(parts[1]) / 60);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facility': facility,
      'role': role,
      'department': department,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'payRate': payRate,
      'status': status.toString().split('.').last,
      'urgency': urgency.toString().split('.').last,
      'distance': distance,
      'matchScore': matchScore,
      'requirements': requirements,
      'description': description,
      'benefits': benefits,
      'facilityRating': facilityRating,
      'shiftNotes': shiftNotes,
      'assignedTo': assignedTo,
      'applicants': applicants,
    };
  }

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'],
      facility: json['facility'],
      role: json['role'],
      department: json['department'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      payRate: json['payRate'].toDouble(),
      status: ShiftStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status']
      ),
      urgency: ShiftUrgency.values.firstWhere(
        (e) => e.toString().split('.').last == json['urgency']
      ),
      distance: json['distance'].toDouble(),
      matchScore: json['matchScore'],
      requirements: List<String>.from(json['requirements']),
      description: json['description'],
      benefits: List<String>.from(json['benefits']),
      facilityRating: json['facilityRating'].toDouble(),
      shiftNotes: json['shiftNotes'],
      assignedTo: json['assignedTo'],
      applicants: json['applicants'],
    );
  }
}