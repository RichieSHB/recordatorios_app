import 'package:flutter/material.dart';
import 'package:recordatorios_app/config/helpers/db_helper.dart';

class CasesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cases = [];
  DateTime? eventDate;
  TimeOfDay? eventTime;
  DateTime? reminderDate;
  TimeOfDay? reminderTime;
  bool formSubmitted = false;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;
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
    DateTime? eventDate,
    TimeOfDay? eventTime,
    DateTime? reminderDate,
    TimeOfDay? reminderTime,
  ) async {
    await DbHelper.insertCase(
      caseName,
      clientName,
      subject,
      description,
      eventDate.toString().split(' ')[0],
      eventTime.toString().split(' ')[0],
      reminderDate.toString().split(' ')[0],
      reminderTime.toString().split(' ')[0],
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

  void clearDates() {
    eventDate = null;
    eventTime = null;
    reminderDate = null;
    reminderTime = null;
    setFormSubmitted(false);
    notifyListeners();
  }

  void setFormSubmitted(bool value) {
    formSubmitted = value;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return _cases.where((c) {
      return DateUtils.isSameDay(DateTime.parse(c['event_date']), day);
    }).toList();
  }
}
