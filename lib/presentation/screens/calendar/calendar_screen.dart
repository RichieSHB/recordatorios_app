import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';
import 'package:recordatorios_app/presentation/providers/theme_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final casesProvider = Provider.of<CasesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Calendario de Casos")),
      body: Column(
        children: [
          TableCalendar(
            //locale: 'es_US',
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(formatButtonVisible: false),
            focusedDay: casesProvider.selectedDate,
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(casesProvider.selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              casesProvider.setSelectedDate(selectedDay);
            },
            eventLoader: (day) {
              return casesProvider.getEventsForDay(day);
            },
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: themeProvider.complementaryColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: themeProvider.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<CasesProvider>(
              builder: (context, provider, child) {
                List<Map<String, dynamic>> events = provider.getEventsForDay(
                  provider.selectedDate,
                );
                if (events.isEmpty) {
                  return Center(child: Text("No hay datos para este dia"));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final caseItem = events[index];
                    return ListTile(
                      title: Text(caseItem['case_name']),
                      subtitle: Text(
                        "Cliente: ${caseItem['client_name']}\nAsunto ${caseItem['subject']}",
                      ),
                      isThreeLine: true,
                      trailing: Icon(Icons.event),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
