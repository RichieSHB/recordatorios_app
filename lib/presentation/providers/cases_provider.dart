import 'package:flutter/material.dart';
import 'package:recordatorios_app/config/helpers/db_helper.dart';

class CasesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cases = [];
  List<Map<String, dynamic>> get cases => _cases;

  Future<void> loadCases() async {
    final cases = await DbHelper.getCases();
    _cases = cases;
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
}
