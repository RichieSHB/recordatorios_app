import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';
import 'package:recordatorios_app/presentation/screens/addCases/add_cases_screen.dart';
import 'package:recordatorios_app/presentation/screens/settings/settings_screen.dart';
import 'package:recordatorios_app/presentation/widgets/home/list_view_recordatorios.dart';
import 'package:recordatorios_app/services/notification_service.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final casesProvider = Provider.of<CasesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios'),
        actions: [
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body:
          casesProvider.cases.isEmpty
              ? Center(
                child: Text(
                  "No hay casos disponibles",
                  style: TextStyle(fontSize: 32),
                ),
              )
              : ListViewRecordatorios(casesProvider: casesProvider),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCasesScreen()),
          ).then((_) {
            casesProvider.clearDates();
          });
        },
        // backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
