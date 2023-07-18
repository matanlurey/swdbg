import 'dart:convert';
import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:file_picker/file_picker.dart';

import '/src/models.dart';

/// Export a deck to a file.
Future<void> export(Deck deck) async {
  // Convert the deck to a (pretty-printed) JSON string.
  final output = const JsonEncoder.withIndent('  ').convert(deck.toJson());

  // Pick an output file.
  if (Platform.isAndroid || Platform.isIOS) {
    // Get a temporary file path.
    final tmpDir = Directory.systemTemp.createTempSync();
    final tmpFile = File('${tmpDir.path}/deck.json');
    await tmpFile.writeAsString(output);
    await CRFileSaver.saveFileWithDialog(
      SaveFileDialogParams(
        sourceFilePath: tmpFile.path,
        destinationFileName: 'deck.json',
      ),
    );
    return;
  }

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
