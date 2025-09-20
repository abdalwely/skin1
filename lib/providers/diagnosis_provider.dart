import 'package:flutter/material.dart';
import '../models/diagnosis_record.dart';
import '../core/services/database_service.dart';

class DiagnosisProvider extends ChangeNotifier {
  List<DiagnosisRecord> _diagnoses = [];
  bool _isLoading = false;
  String? _error;

  List<DiagnosisRecord> get diagnoses => _diagnoses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get reviewedCount => _diagnoses.where((d) => d.isReviewed).length;
  int get pendingCount => _diagnoses.where((d) => !d.isReviewed).length;

  Future<void> loadDiagnoses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _diagnoses = await DatabaseService.instance.getAllDiagnosisRecords();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDiagnosis(DiagnosisRecord diagnosis) async {
    try {
      await DatabaseService.instance.insertDiagnosisRecord(diagnosis);
      _diagnoses.insert(0, diagnosis);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateDiagnosis(DiagnosisRecord diagnosis) async {
    try {
      await DatabaseService.instance.updateDiagnosisRecord(diagnosis);
      final index = _diagnoses.indexWhere((d) => d.id == diagnosis.id);
      if (index != -1) {
        _diagnoses[index] = diagnosis;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteDiagnosis(String diagnosisId) async {
    try {
      await DatabaseService.instance.deleteDiagnosisRecord(diagnosisId);
      _diagnoses.removeWhere((d) => d.id == diagnosisId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<DiagnosisRecord> getPatientDiagnoses(String patientId) {
    return _diagnoses.where((d) => d.patientId == patientId).toList();
  }

  DiagnosisRecord? getDiagnosis(String diagnosisId) {
    try {
      return _diagnoses.firstWhere((d) => d.id == diagnosisId);
    } catch (e) {
      return null;
    }
  }

  Map<String, int> getDiseaseStatistics() {
    final stats = <String, int>{};
    for (final diagnosis in _diagnoses) {
      stats[diagnosis.predictedClass] = (stats[diagnosis.predictedClass] ?? 0) + 1;
    }
    return stats;
  }

  List<DiagnosisRecord> getDiagnosesByDateRange(DateTime start, DateTime end) {
    return _diagnoses.where((d) {
      return d.createdAt.isAfter(start) && d.createdAt.isBefore(end);
    }).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}