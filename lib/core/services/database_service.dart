import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/patient.dart';
import '../../models/diagnosis_record.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('skin_diseases.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // جدول المرضى
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        date_of_birth TEXT NOT NULL,
        gender TEXT NOT NULL,
        address TEXT NOT NULL,
        medical_history TEXT,
        allergies TEXT,
        current_medications TEXT,
        emergency_contact TEXT,
        emergency_contact_phone TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        profile_image_path TEXT,
        notes TEXT,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // جدول سجلات التشخيص
    await db.execute('''
      CREATE TABLE diagnosis_records (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        image_path TEXT NOT NULL,
        predicted_class TEXT NOT NULL,
        class_name TEXT NOT NULL,
        confidence REAL NOT NULL,
        all_probabilities TEXT NOT NULL,
        created_at TEXT NOT NULL,
        doctor_notes TEXT,
        treatment_plan TEXT,
        follow_up_date TEXT,
        is_reviewed INTEGER DEFAULT 0,
        reviewed_by TEXT,
        reviewed_at TEXT,
        severity TEXT DEFAULT 'unknown',
        symptoms TEXT,
        location TEXT,
        size TEXT,
        color TEXT,
        texture TEXT,
        is_painful INTEGER DEFAULT 0,
        is_itchy INTEGER DEFAULT 0,
        duration TEXT,
        additional_images TEXT,
        FOREIGN KEY (patient_id) REFERENCES patients (id)
      )
    ''');

    // جدول الإعدادات
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // جدول الإشعارات
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        type TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        data TEXT
      )
    ''');

    // إدراج الإعدادات الافتراضية
    await _insertDefaultSettings(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // منطق ترقية قاعدة البيانات
    if (oldVersion < 2) {
      // إضافة أعمدة جديدة أو جداول جديدة
    }
  }

  Future<void> _insertDefaultSettings(Database db) async {
    final defaultSettings = [
      {'key': 'theme_mode', 'value': 'system'},
      {'key': 'language', 'value': 'ar'},
      {'key': 'text_scale', 'value': '1.0'},
      {'key': 'notifications_enabled', 'value': 'true'},
      {'key': 'auto_backup', 'value': 'true'},
      {'key': 'backup_frequency', 'value': 'weekly'},
    ];

    for (final setting in defaultSettings) {
      await db.insert(
        'settings',
        {
          ...setting,
          'updated_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // عمليات المرضى
  Future<String> insertPatient(Patient patient) async {
    final db = await database;
    await db.insert('patients', _patientToMap(patient));
    return patient.id;
  }

  Future<List<Patient>> getAllPatients() async {
    final db = await database;
    final result = await db.query(
      'patients',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return result.map((map) => _patientFromMap(map)).toList();
  }

  Future<Patient?> getPatient(String id) async {
    final db = await database;
    final result = await db.query(
      'patients',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return _patientFromMap(result.first);
    }
    return null;
  }

  Future<void> updatePatient(Patient patient) async {
    final db = await database;
    await db.update(
      'patients',
      _patientToMap(patient),
      where: 'id = ?',
      whereArgs: [patient.id],
    );
  }

  Future<void> deletePatient(String id) async {
    final db = await database;
    await db.update(
      'patients',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // عمليات سجلات التشخيص
  Future<String> insertDiagnosisRecord(DiagnosisRecord record) async {
    final db = await database;
    await db.insert('diagnosis_records', _diagnosisRecordToMap(record));
    return record.id;
  }

  Future<List<DiagnosisRecord>> getAllDiagnosisRecords() async {
    final db = await database;
    final result = await db.query(
      'diagnosis_records',
      orderBy: 'created_at DESC',
    );
    return result.map((map) => _diagnosisRecordFromMap(map)).toList();
  }

  Future<List<DiagnosisRecord>> getPatientDiagnosisRecords(String patientId) async {
    final db = await database;
    final result = await db.query(
      'diagnosis_records',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => _diagnosisRecordFromMap(map)).toList();
  }

  Future<DiagnosisRecord?> getDiagnosisRecord(String id) async {
    final db = await database;
    final result = await db.query(
      'diagnosis_records',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return _diagnosisRecordFromMap(result.first);
    }
    return null;
  }

  Future<void> updateDiagnosisRecord(DiagnosisRecord record) async {
    final db = await database;
    await db.update(
      'diagnosis_records',
      _diagnosisRecordToMap(record),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<void> deleteDiagnosisRecord(String id) async {
    final db = await database;
    await db.delete(
      'diagnosis_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // عمليات الإعدادات
  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String;
    }
    return null;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'settings',
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // إحصائيات
  Future<Map<String, int>> getStatistics() async {
    final db = await database;
    
    final patientsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM patients WHERE is_active = 1')
    ) ?? 0;
    
    final diagnosisCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM diagnosis_records')
    ) ?? 0;
    
    final reviewedCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM diagnosis_records WHERE is_reviewed = 1')
    ) ?? 0;
    
    return {
      'patients': patientsCount,
      'diagnoses': diagnosisCount,
      'reviewed': reviewedCount,
      'pending': diagnosisCount - reviewedCount,
    };
  }

  // البحث
  Future<List<Patient>> searchPatients(String query) async {
    final db = await database;
    final result = await db.query(
      'patients',
      where: 'is_active = 1 AND (name LIKE ? OR phone LIKE ? OR email LIKE ?)',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((map) => _patientFromMap(map)).toList();
  }

  // تحويل البيانات
  Map<String, dynamic> _patientToMap(Patient patient) {
    return {
      'id': patient.id,
      'name': patient.name,
      'phone': patient.phone,
      'email': patient.email,
      'date_of_birth': patient.dateOfBirth.toIso8601String(),
      'gender': patient.gender,
      'address': patient.address,
      'medical_history': patient.medicalHistory,
      'allergies': patient.allergies,
      'current_medications': patient.currentMedications,
      'emergency_contact': patient.emergencyContact,
      'emergency_contact_phone': patient.emergencyContactPhone,
      'created_at': patient.createdAt.toIso8601String(),
      'updated_at': patient.updatedAt.toIso8601String(),
      'profile_image_path': patient.profileImagePath,
      'notes': patient.notes,
      'is_active': patient.isActive ? 1 : 0,
    };
  }

  Patient _patientFromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      dateOfBirth: DateTime.parse(map['date_of_birth']),
      gender: map['gender'],
      address: map['address'],
      medicalHistory: map['medical_history'] ?? '',
      allergies: map['allergies'] ?? '',
      currentMedications: map['current_medications'] ?? '',
      emergencyContact: map['emergency_contact'] ?? '',
      emergencyContactPhone: map['emergency_contact_phone'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      profileImagePath: map['profile_image_path'],
      notes: map['notes'],
      isActive: map['is_active'] == 1,
    );
  }

  Map<String, dynamic> _diagnosisRecordToMap(DiagnosisRecord record) {
    return {
      'id': record.id,
      'patient_id': record.patientId,
      'image_path': record.imagePath,
      'predicted_class': record.predictedClass,
      'class_name': record.className,
      'confidence': record.confidence,
      'all_probabilities': record.allProbabilities.toString(),
      'created_at': record.createdAt.toIso8601String(),
      'doctor_notes': record.doctorNotes,
      'treatment_plan': record.treatmentPlan,
      'follow_up_date': record.followUpDate,
      'is_reviewed': record.isReviewed ? 1 : 0,
      'reviewed_by': record.reviewedBy,
      'reviewed_at': record.reviewedAt?.toIso8601String(),
      'severity': record.severity,
      'symptoms': record.symptoms.join(','),
      'location': record.location,
      'size': record.size,
      'color': record.color,
      'texture': record.texture,
      'is_painful': record.isPainful ? 1 : 0,
      'is_itchy': record.isItchy ? 1 : 0,
      'duration': record.duration,
      'additional_images': record.additionalImages.join(','),
    };
  }

  DiagnosisRecord _diagnosisRecordFromMap(Map<String, dynamic> map) {
    return DiagnosisRecord(
      id: map['id'],
      patientId: map['patient_id'],
      imagePath: map['image_path'],
      predictedClass: map['predicted_class'],
      className: map['class_name'],
      confidence: map['confidence'],
      allProbabilities: _parseAllProbabilities(map['all_probabilities']),
      createdAt: DateTime.parse(map['created_at']),
      doctorNotes: map['doctor_notes'],
      treatmentPlan: map['treatment_plan'],
      followUpDate: map['follow_up_date'],
      isReviewed: map['is_reviewed'] == 1,
      reviewedBy: map['reviewed_by'],
      reviewedAt: map['reviewed_at'] != null 
          ? DateTime.parse(map['reviewed_at']) 
          : null,
      severity: map['severity'] ?? 'unknown',
      symptoms: map['symptoms']?.split(',') ?? [],
      location: map['location'],
      size: map['size'],
      color: map['color'],
      texture: map['texture'],
      isPainful: map['is_painful'] == 1,
      isItchy: map['is_itchy'] == 1,
      duration: map['duration'],
      additionalImages: map['additional_images']?.split(',') ?? [],
    );
  }

  Map<String, double> _parseAllProbabilities(String probabilities) {
    // تحويل النص إلى Map
    // هذا مثال بسيط، يمكن تحسينه باستخدام JSON
    return {'example': 0.5}; // يجب تحسين هذا
  }

  Future<void> initialize() async {
    await database;
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}