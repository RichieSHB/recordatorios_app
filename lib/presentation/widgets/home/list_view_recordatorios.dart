import 'package:flutter/material.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';

class ListViewRecordatorios extends StatelessWidget {
  const ListViewRecordatorios({super.key, required this.casesProvider});

  final CasesProvider casesProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: casesProvider.cases.length,
      itemBuilder: (context, index) {
        final caseData = casesProvider.cases[index];
        return Dismissible(
          key: Key(caseData['id'].toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            await casesProvider.deleteCase(caseData['id']);
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Caso Eliminado")));
            }
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            leading: Icon(Icons.event),
            title: Text(casesProvider.cases[index]['case_name']),
            subtitle: Text(casesProvider.cases[index]['client_name']),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        );
      },
    );
  }
}
