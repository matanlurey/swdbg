import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '/src/models.dart';

/// Export a deck to a file.
Future<void> export(Deck deck) async {
  // Convert the deck to a (pretty-printed) JSON string.
  final output = const JsonEncoder.withIndent('  ').convert(deck.toJson());

  // Pick an output file.
  final name = await FilePicker.platform.saveFile(
    fileName: 'deck.json',
    allowedExtensions: ['json'],
    dialogTitle: 'Export Deck',
    type: FileType.custom,
  );

  if (name == null) {
    return;
  }

  // Write the file.
  await File(name).writeAsString(output);
}

/// Import a deck from a file.
Future<Deck?> import() async {
  // Pick an input file.
  final name = await FilePicker.platform.pickFiles(
    allowedExtensions: ['json'],
    dialogTitle: 'Import Deck',
    type: FileType.custom,
  );

  if (name == null) {
    return null;
  }

  // Read the JSON file.
  final input = await File(name.files.single.path!).readAsString();
  return Deck.fromJson(jsonDecode(input) as Map<String, Object?>);
}
