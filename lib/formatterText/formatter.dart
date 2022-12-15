import 'package:flutter/services.dart';

class DecimalFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    const int decimals = 2;
    final String onlyNumbers = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final String finalValue =
        onlyNumbers != '00' ? _applyMaskTo(onlyNumbers, decimals) : '';
    return newValue.copyWith(
        text: finalValue,
        selection: TextSelection.fromPosition(
            TextPosition(offset: finalValue.length)));
  }

  String _applyMaskTo(String value, int decimals) {
    List<String> textRepresentation =
        value.split('').reversed.toList(growable: true);

    while (textRepresentation.length <= decimals) {
      textRepresentation.insert(value.length, '0');
    }

    textRepresentation.insert(decimals, '.');

    while (textRepresentation.length >= decimals + 3 &&
        textRepresentation.last == '0') {
      textRepresentation.removeLast();
    }

    return textRepresentation.reversed.join('');
  }
}
