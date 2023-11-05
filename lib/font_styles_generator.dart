import 'dart:convert';
import 'dart:io';

String toValidDartIdentifier(String input) {
  return input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
}

void fontGenerator(List<String> args) {
  if (args.length != 2) {
    print("Usage: dart generate_text_styles.dart <input.json> <output.dart>");
    exit(1);
  }

  final inputJsonFile = args[0];
  final outputDartFile = args[1];

  final jsonContent = File(inputJsonFile).readAsStringSync();
  final List<dynamic> styles = json.decode(jsonContent);

  final output = StringBuffer();
  output.writeln("import 'package:flutter/material.dart';");
  output.writeln('extension StringTextStyleExtensions on String {');

  for (final style in styles) {
    final styleName = toValidDartIdentifier(style['styleName']);
    final fontFamily = style['font-family'];
    final fontSize = double.parse(style['font-size'].replaceAll('px', ''));
    final fontWeight = style['font-weight'];

    output.writeln('  Text $styleName({');
    output.writeln('    Color? color,');
    output.writeln('    TextAlign? textAlign,');
    output.writeln('    double? height,');
    output.writeln('    double fontSize = $fontSize,');
    output.writeln('  }) {');
    output.writeln('    return Text(');
    output.writeln('      this,');
    output.writeln('      textAlign: textAlign,');
    output.writeln('      style: TextStyle(');
    output.writeln('        fontSize: fontSize,');
    output.writeln('        fontFamily: "$fontFamily",');
    output.writeln('        fontWeight: FontWeight.w$fontWeight,');
    output.writeln('        color: color ?? const Color(0xff1E232C),');
    output.writeln('        height: height,');
    output.writeln('      ),');
    output.writeln('    );');
    output.writeln('  }');
  }

  output.writeln('}');

  File(outputDartFile).writeAsStringSync(output.toString());
  print('Text style extensions generated in $outputDartFile');
}
