import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';

class AddCasesScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController caseNameController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final casesProvider = Provider.of<CasesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Agregar Caso")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: caseNameController,
                decoration: InputDecoration(labelText: "Nombre del Caso"),
              ),
              TextFormField(
                controller: clientNameController,
                decoration: InputDecoration(labelText: "Nombre del Cliente"),
              ),
              TextFormField(
                controller: subjectController,
                decoration: InputDecoration(labelText: "Asunto"),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Descripcion"),
              ),
              _ListTileDatePicker(casesProvider: casesProvider, isEvent: true),
              _ListTileTimePicker(casesProvider: casesProvider, isEvent: true),
              _ListTileDatePicker(casesProvider: casesProvider, isEvent: false),
              _ListTileTimePicker(casesProvider: casesProvider, isEvent: false),
              ElevatedButton(
                onPressed: () {
                  casesProvider.addCase(
                    caseNameController.text,
                    clientNameController.text,
                    subjectController.text,
                    descriptionController.text,
                    casesProvider.eventDate.toString().split(' ')[0],
                    casesProvider.eventTime.toString().split(' ')[0],
                    casesProvider.reminderDate.toString().split(' ')[0],
                    casesProvider.reminderTime.toString().split(' ')[0],
                  );
                  Navigator.pop(context);
                },
                child: Text("Guardar caso"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTileTimePicker extends StatelessWidget {
  const _ListTileTimePicker({
    required this.casesProvider,
    required this.isEvent,
  });

  final CasesProvider casesProvider;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: isEvent ? Text("Hora del Evento") : Text("Hora del Recordatorio"),
      subtitle:
          isEvent
              ? _SubtitleEventTime(casesProvider: casesProvider)
              : _SubtitleReminderTime(casesProvider: casesProvider),
      trailing: Icon(Icons.access_time),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          casesProvider.selectTime(picked, isEvent);
        }
      },
    );
  }
}

class _SubtitleEventTime extends StatelessWidget {
  const _SubtitleEventTime({required this.casesProvider});

  final CasesProvider casesProvider;

  @override
  Widget build(BuildContext context) {
    return Text(
      casesProvider.eventTime != null
          ? casesProvider.eventTime!.format(context)
          : "Selecciona la Hora del Evento",
    );
  }
}

class _SubtitleReminderTime extends StatelessWidget {
  const _SubtitleReminderTime({required this.casesProvider});

  final CasesProvider casesProvider;

  @override
  Widget build(BuildContext context) {
    return Text(
      casesProvider.reminderTime != null
          ? casesProvider.reminderTime!.format(context)
          : "Selecciona la Hora del Evento",
    );
  }
}

class _ListTileDatePicker extends StatelessWidget {
  const _ListTileDatePicker({
    required this.casesProvider,
    required this.isEvent,
  });

  final CasesProvider casesProvider;
  final bool isEvent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          isEvent ? Text("Fecha del Evento") : Text("Fecha del Recordatorio"),
      subtitle:
          isEvent
              ? _SubtitleEventDate(casesProvider: casesProvider)
              : _SubtitleReminderDate(casesProvider: casesProvider),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          casesProvider.selectDate(picked, isEvent);
        }
      },
    );
  }
}

class _SubtitleEventDate extends StatelessWidget {
  const _SubtitleEventDate({required this.casesProvider});

  final CasesProvider casesProvider;

  @override
  Widget build(BuildContext context) {
    return Text(
      casesProvider.eventDate != null
          ? casesProvider.eventDate!.toString().split(' ')[0]
          : "Selecciona Fecha del Evento",
    );
  }
}

class _SubtitleReminderDate extends StatelessWidget {
  const _SubtitleReminderDate({required this.casesProvider});

  final CasesProvider casesProvider;

  @override
  Widget build(BuildContext context) {
    return Text(
      casesProvider.reminderDate != null
          ? casesProvider.reminderDate!.toString().split(' ')[0]
          : "Selecciona Fecha del Evento",
    );
  }
}
