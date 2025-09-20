import 'package:hive/hive.dart';

part 'diagnosis_record.g.dart';

@HiveType(typeId: 1)
class DiagnosisRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String patientId;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  String predictedClass;

  @HiveField(4)
  String className;

  @HiveField(5)
  double confidence;

  @HiveField(6)
  Map<String, double> allProbabilities;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  String? doctorNotes;

  @HiveField(9)
  String? treatmentPlan;

  @HiveField(10)
  String? followUpDate;

  @HiveField(11)
  bool isReviewed;

  @HiveField(12)
  String? reviewedBy;

  @HiveField(13)
  DateTime? reviewedAt;

  @HiveField(14)
  String severity;

  @HiveField(15)
  List<String> symptoms;

  @HiveField(16)
  String? location;

  @HiveField(17)
  String? size;

  @HiveField(18)
  String? color;

  @HiveField(19)
  String? texture;

  @HiveField(20)
  bool isPainful;

  @HiveField(21)
  bool isItchy;

  @HiveField(22)
  String? duration;

  @HiveField(23)
  List<String> additionalImages;

  DiagnosisRecord({
    required this.id,
    required this.patientId,
    required this.imagePath,
    required this.predictedClass,
    required this.className,
    required this.confidence,
    required this.allProbabilities,
    required this.createdAt,
    this.doctorNotes,
    this.treatmentPlan,
    this.followUpDate,
    this.isReviewed = false,
    this.reviewedBy,
    this.reviewedAt,
    this.severity = 'unknown',
    this.symptoms = const [],
    this.location,
    this.size,
    this.color,
    this.texture,
    this.isPainful = false,
    this.isItchy = false,
    this.duration,
    this.additionalImages = const [],
  });

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'imagePath': imagePath,
      'predictedClass': predictedClass,
      'className': className,
      'confidence': confidence,
      'allProbabilities': allProbabilities,
      'createdAt': createdAt.toIso8601String(),
      'doctorNotes': doctorNotes,
      'treatmentPlan': treatmentPlan,
      'followUpDate': followUpDate,
      'isReviewed': isReviewed,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'severity': severity,
      'symptoms': symptoms,
      'location': location,
      'size': size,
      'color': color,
      'texture': texture,
      'isPainful': isPainful,
      'isItchy': isItchy,
      'duration': duration,
      'additionalImages': additionalImages,
    };
  }

  // إنشاء من JSON
  factory DiagnosisRecord.fromJson(Map<String, dynamic> json) {
    return DiagnosisRecord(
      id: json['id'],
      patientId: json['patientId'],
      imagePath: json['imagePath'],
      predictedClass: json['predictedClass'],
      className: json['className'],
      confidence: json['confidence'].toDouble(),
      allProbabilities: Map<String, double>.from(json['allProbabilities']),
      createdAt: DateTime.parse(json['createdAt']),
      doctorNotes: json['doctorNotes'],
      treatmentPlan: json['treatmentPlan'],
      followUpDate: json['followUpDate'],
      isReviewed: json['isReviewed'] ?? false,
      reviewedBy: json['reviewedBy'],
      reviewedAt: json['reviewedAt'] != null 
          ? DateTime.parse(json['reviewedAt']) 
          : null,
      severity: json['severity'] ?? 'unknown',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      location: json['location'],
      size: json['size'],
      color: json['color'],
      texture: json['texture'],
      isPainful: json['isPainful'] ?? false,
      isItchy: json['isItchy'] ?? false,
      duration: json['duration'],
      additionalImages: List<String>.from(json['additionalImages'] ?? []),
    );
  }

  // نسخ مع تعديل
  DiagnosisRecord copyWith({
    String? doctorNotes,
    String? treatmentPlan,
    String? followUpDate,
    bool? isReviewed,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? severity,
    List<String>? symptoms,
    String? location,
    String? size,
    String? color,
    String? texture,
    bool? isPainful,
    bool? isItchy,
    String? duration,
    List<String>? additionalImages,
  }) {
    return DiagnosisRecord(
      id: id,
      patientId: patientId,
      imagePath: imagePath,
      predictedClass: predictedClass,
      className: className,
      confidence: confidence,
      allProbabilities: allProbabilities,
      createdAt: createdAt,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      treatmentPlan: treatmentPlan ?? this.treatmentPlan,
      followUpDate: followUpDate ?? this.followUpDate,
      isReviewed: isReviewed ?? this.isReviewed,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      severity: severity ?? this.severity,
      symptoms: symptoms ?? this.symptoms,
      location: location ?? this.location,
      size: size ?? this.size,
      color: color ?? this.color,
      texture: texture ?? this.texture,
      isPainful: isPainful ?? this.isPainful,
      isItchy: isItchy ?? this.isItchy,
      duration: duration ?? this.duration,
      additionalImages: additionalImages ?? this.additionalImages,
    );
  }

  @override
  String toString() {
    return 'DiagnosisRecord(id: $id, patientId: $patientId, className: $className, confidence: $confidence)';
  }
}