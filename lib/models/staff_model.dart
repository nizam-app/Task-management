enum StaffStatus { active, inactive, suspended }
enum CredentialStatus { verified, pending, expired, expiring }

class Staff {
  final String id;
  final String name;
  final String role;
  final List<String> specialties;
  final double rating;
  final int totalShifts;
  final StaffStatus status;
  final CredentialStatus credentialsStatus;
  final int credentialsExpiring;
  final DateTime lastActive;
  final String phone;
  final String email;
  final String avatar;
  final String? location;

  Staff({
    required this.id,
    required this.name,
    required this.role,
    required this.specialties,
    required this.rating,
    required this.totalShifts,
    required this.status,
    required this.credentialsStatus,
    this.credentialsExpiring = 0,
    required this.lastActive,
    required this.phone,
    required this.email,
    required this.avatar,
    this.location,
  });

  String get lastActiveString {
    final now = DateTime.now();
    final difference = now.difference(lastActive);
    
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return '1 day ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'specialties': specialties,
      'rating': rating,
      'totalShifts': totalShifts,
      'status': status.toString().split('.').last,
      'credentialsStatus': credentialsStatus.toString().split('.').last,
      'credentialsExpiring': credentialsExpiring,
      'lastActive': lastActive.toIso8601String(),
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'location': location,
    };
  }

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      specialties: List<String>.from(json['specialties']),
      rating: json['rating'].toDouble(),
      totalShifts: json['totalShifts'],
      status: StaffStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status']
      ),
      credentialsStatus: CredentialStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['credentialsStatus']
      ),
      credentialsExpiring: json['credentialsExpiring'],
      lastActive: DateTime.parse(json['lastActive']),
      phone: json['phone'],
      email: json['email'],
      avatar: json['avatar'],
      location: json['location'],
    );
  }
}

class Credential {
  final String id;
  final String name;
  final CredentialStatus status;
  final DateTime expiryDate;
  final DateTime uploadDate;
  final bool verified;
  final String? documentUrl;

  Credential({
    required this.id,
    required this.name,
    required this.status,
    required this.expiryDate,
    required this.uploadDate,
    required this.verified,
    this.documentUrl,
  });

  int get daysUntilExpiry {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.toString().split('.').last,
      'expiryDate': expiryDate.toIso8601String(),
      'uploadDate': uploadDate.toIso8601String(),
      'verified': verified,
      'documentUrl': documentUrl,
    };
  }

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      id: json['id'],
      name: json['name'],
      status: CredentialStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status']
      ),
      expiryDate: DateTime.parse(json['expiryDate']),
      uploadDate: DateTime.parse(json['uploadDate']),
      verified: json['verified'],
      documentUrl: json['documentUrl'],
    );
  }
}