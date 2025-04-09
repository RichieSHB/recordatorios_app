import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recordatorios_app/presentation/providers/theme_provider.dart';
import 'package:recordatorios_app/presentation/widgets/colorpicker/color_picker_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Configuracion")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text("Modo Oscuro"),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleDarkMode(value);
            },
          ),
          ListTile(
            title: Text("Seleccionar Color Primario"),
            trailing: CircleAvatar(backgroundColor: themeProvider.primaryColor),
            onTap: () {
              _openColorPickerDialog(context, themeProvider);
            },
          ),
        ],
      ),
    );
  }
}

void _openColorPickerDialog(BuildContext context, ThemeProvider themeProvider) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Selecciona un color"),
        content: SingleChildScrollView(
          child: ColorPickerWidget(
            onColorSelected: (color) {
              themeProvider.updatePrimaryColor(color);
              Navigator.pop(context);
            },
            selectedColor: themeProvider.primaryColor,
          ),
        ),
      );
    },
  );
}
