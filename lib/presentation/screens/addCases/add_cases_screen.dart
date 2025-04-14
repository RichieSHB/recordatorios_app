import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/cases_provider.dart';
import 'package:recordatorios_app/services/notification_service.dart';

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
              _CustomTextFormField(
                textController: caseNameController,
                validatorString: 'Por favor ingrese el nombre del caso',
                labelString: 'Nombre del Caso',
              ),
              _CustomTextFormField(
                textController: clientNameController,
                validatorString: 'Por favor ingrese el nombre del cliente',
                labelString: 'Nombre del Cliente',
              ),
              _CustomTextFormField(
                textController: subjectController,
                validatorString: 'Por favor ingrese el asunto',
                labelString: 'Asunto',
              ),
              _CustomTextFormField(
                textController: descriptionController,
                validatorString: 'Por favor ingrese la descripcion',
                labelString: 'Descripcion',
              ),
              _ListTileDatePicker(
                casesProvider: casesProvider,
                isEvent: true,
                errorText:
                    casesProvider.formSubmitted &&
                            casesProvider.eventDate == null
                        ? 'Selecciona la fecha del evento'
                        : null,
              ),
              _ListTileTimePicker(
                casesProvider: casesProvider,
                isEvent: true,
                errorText:
                    casesProvider.formSubmitted &&
                            casesProvider.eventTime == null
                        ? 'Selecciona la hora del evento'
                        : null,
              ),
              _ListTileDatePicker(
                casesProvider: casesProvider,
                isEvent: false,
                errorText:
                    casesProvider.formSubmitted &&
                            casesProvider.reminderDate == null
                        ? 'Selecciona la fecha del recordatorio'
                        : null,
              ),
              _ListTileTimePicker(
                casesProvider: casesProvider,
                isEvent: false,
                errorText:
                    casesProvider.formSubmitted &&
                            casesProvider.eventTime == null
                        ? 'Selecciona la hora del recordatorio'
                        : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  casesProvider.setFormSubmitted(true);
                  if (_formKey.currentState!.validate()) {
                    final DateTime scheduledDate = DateTime(
                      casesProvider.reminderDate!.year,
                      casesProvider.reminderDate!.month,
                      casesProvider.reminderDate!.day,
                      casesProvider.reminderTime!.hour,
                      casesProvider.reminderTime!.minute,
                    );
                    NotificationService.scheduleNotification(
                      title: caseNameController.text,
                      body:
                          '${subjectController.text} ${descriptionController.text}',
                      scheduledDate: scheduledDate,
                    );

                    await casesProvider.addCase(
                      caseNameController.text,
                      clientNameController.text,
                      subjectController.text,
                      descriptionController.text,
                      casesProvider.eventDate,
                      casesProvider.eventTime,
                      casesProvider.reminderDate,
                      casesProvider.reminderTime,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
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

class _CustomTextFormField extends StatelessWidget {
  const _CustomTextFormField({
    required this.textController,
    required this.validatorString,
    required this.labelString,
  });

  final TextEditingController textController;
  final String validatorString;
  final String labelString;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorString;
        }
        return null;
      },
      controller: textController,
      decoration: InputDecoration(labelText: labelString),
    );
  }
}

class _ListTileTimePicker extends StatelessWidget {
  const _ListTileTimePicker({
    required this.casesProvider,
    required this.isEvent,
    this.errorText,
  });

  final CasesProvider casesProvider;
  final bool isEvent;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title:
              isEvent ? Text("Hora del Evento") : Text("Hora del Recordatorio"),
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
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
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
    this.errorText,
  });

  final CasesProvider casesProvider;
  final bool isEvent;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title:
              isEvent
                  ? Text("Fecha del Evento")
                  : Text("Fecha del Recordatorio"),
          subtitle:
              isEvent
                  ? _SubtitleEventDate(casesProvider: casesProvider)
                  : _SubtitleReminderDate(casesProvider: casesProvider),
          //leading: Icon(Icons.abc_outlined),
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
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
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
