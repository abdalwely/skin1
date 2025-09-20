import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../core/services/database_service.dart';

class PatientProvider extends ChangeNotifier {
  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _error;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      _patients = await DatabaseService.instance.getAllPatients();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      await DatabaseService.instance.insertPatient(patient);
      _patients.add(patient);
      _patients.sort((a, b) => a.name.compareTo(b.name));
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePatient(Patient patient) async {
    try {
      await DatabaseService.instance.updatePatient(patient);
      final index = _patients.indexWhere((p) => p.id == patient.id);
      if (index != -1) {
        _patients[index] = patient;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      await DatabaseService.instance.deletePatient(patientId);
      _patients.removeWhere((p) => p.id == patientId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<Patient>> searchPatients(String query) async {
    try {
      return await DatabaseService.instance.searchPatients(query);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Patient? getPatient(String patientId) {
    try {
      return _patients.firstWhere((p) => p.id == patientId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}