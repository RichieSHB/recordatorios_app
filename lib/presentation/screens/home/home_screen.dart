import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final casesProvider = Provider.of<CasesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios'),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
      ),
      body:
          casesProvider.cases.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: casesProvider.cases.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.event),
                    title: Text(casesProvider.cases[index]['case_name']),
                    subtitle: Text(casesProvider.cases[index]['client_name']),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await casesProvider.addCase(
            'Caso Ejemplo',
            'Cliente Ejemplo',
            'Asunto Ejemplo',
            'Descripcion Evento',
            '2025-04-02',
            '14:00',
            '2025-04-01',
            '12:00',
          );
        },
        // backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
