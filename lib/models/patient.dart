import 'package:hive/hive.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String email;

  @HiveField(4)
  DateTime dateOfBirth;

  @HiveField(5)
  String gender;

  @HiveField(6)
  String address;

  @HiveField(7)
  String medicalHistory;

  @HiveField(8)
  String allergies;

  @HiveField(9)
  String currentMedications;

  @HiveField(10)
  String emergencyContact;

  @HiveField(11)
  String emergencyContactPhone;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime updatedAt;

  @HiveField(14)
  String? profileImagePath;

  @HiveField(15)
  String? notes;

  @HiveField(16)
  bool isActive;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.medicalHistory = '',
    this.allergies = '',
    this.currentMedications = '',
    this.emergencyContact = '',
    this.emergencyContactPhone = '',
    required this.createdAt,
    required this.updatedAt,
    this.profileImagePath,
    this.notes,
    this.isActive = true,
  });

  // حساب العمر
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'address': address,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'currentMedications': currentMedications,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profileImagePath': profileImagePath,
      'notes': notes,
      'isActive': isActive,
    };
  }

  // إنشاء من JSON
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      address: json['address'],
      medicalHistory: json['medicalHistory'] ?? '',
      allergies: json['allergies'] ?? '',
      currentMedications: json['currentMedications'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      emergencyContactPhone: json['emergencyContactPhone'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      profileImagePath: json['profileImagePath'],
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
    );
  }

  // نسخ مع تعديل
  Patient copyWith({
    String? name,
    String? phone,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? medicalHistory,
    String? allergies,
    String? currentMedications,
    String? emergencyContact,
    String? emergencyContactPhone,
    DateTime? updatedAt,
    String? profileImagePath,
    String? notes,
    bool? isActive,
  }) {
    return Patient(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      profileImagePath: profileImagePath ?? this.profileImagePath,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Patient(id: $id, name: $name, phone: $phone, age: $age)';
  }
}