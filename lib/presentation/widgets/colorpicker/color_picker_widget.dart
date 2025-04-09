import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;
  const ColorPickerWidget({
    super.key,
    required this.onColorSelected,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlockPicker(
      pickerColor: selectedColor,
      onColorChanged: (color) {
        onColorSelected(color);
      },
    );
  }
}
