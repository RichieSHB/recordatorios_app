import 'package:flutter/material.dart';
import 'package:recordatorios_app/config/helpers/db_helper.dart';

class CasesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cases = [];
  DateTime? eventDate;
  TimeOfDay? eventTime;
  DateTime? reminderDate;
  TimeOfDay? reminderTime;

  List<Map<String, dynamic>> get cases => _cases;

  Future<void> loadCases() async {
    try {
      final cases = await DbHelper.getCases();
      _cases = cases;
    } catch (e) {
      _cases = [];
    }
    notifyListeners();
  }

  Future<void> addCase(
    String caseName,
    String clientName,
    String subject,
    String description,
    String eventDate,
    String eventTime,
    String reminderDate,
    String reminderTime,
  ) async {
    await DbHelper.insertCase(
      caseName,
      clientName,
      subject,
      description,
      eventDate,
      eventTime,
      reminderDate,
      reminderTime,
    );
    await loadCases();
  }

  Future<void> deleteCase(int id) async {
    await DbHelper.deleteCase(id);
    await loadCases();
  }

  void selectDate(DateTime picked, bool isEvent) {
    if (isEvent) {
      eventDate = picked;
    } else {
      reminderDate = picked;
    }
    notifyListeners();
  }

  void selectTime(TimeOfDay picked, bool isEvent) {
    if (isEvent) {
      eventTime = picked;
    } else {
      reminderTime = picked;
    }
    notifyListeners();
  }
}
