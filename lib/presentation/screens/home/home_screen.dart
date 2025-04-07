import 'package:flutter/material.dart';
import 'package:recordatorios_app/presentation/screens/calendar/calendar_screen.dart';
import 'package:recordatorios_app/presentation/screens/cases/cases_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  final List<Widget> _screens = [CasesScreen(), CalendarScreen()];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, currentIndex, _) {
        return Scaffold(
          body: _screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _selectedIndex.value = index,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Casos'),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Calendario',
              ),
            ],
          ),
        );
      },
    );
  }
}
