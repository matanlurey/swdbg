import 'dart:convert';
import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '/src/models.dart';
import '/src/utils.dart';

/// The path to the recent decks file.
Future<String> get _recentPath async {
  final appData = await getApplicationDocumentsDirectory();

  // Create the 'recent' directory if it does not exist.
  final result = p.join(appData.path, 'recent');
  await Directory(result).create(recursive: true);

  return result;
}

extension on Deck {
  /// A suggested file name for this deck.
  String get suggestedFileName {
    // Get a short timestamp by base64 encoding the unix time.
    final time = '${DateTime.now().millisecondsSinceEpoch}';
    final unique = utf8.fuse(base64Url).encode(time);
    return '${faction.name}-${cards.length}-cards-$unique.json';
  }
}

/// Automatically save a deck to `%APPDATA%/recent`.
///
/// If there are more than 10 recent decks, delete the oldest.
Future<Uri> autoSave(Deck deck) async {
  final recentPath = await _recentPath;

  // Write the deck.
  final output = const JsonEncoder.withIndent('  ').convert(deck.toJson());

  final String outputPath;
  if (deck.autoSaved && deck.uri?.scheme == 'file') {
    outputPath = deck.uri!.toFilePath();
  } else {
    outputPath = p.join(recentPath, deck.suggestedFileName);
  }

  await File(outputPath).writeAsString(output);

  // Retrieve all decks saved, sorted by last modified.
  final recentWithLastModified = await Directory(recentPath)
      .list()
      .whereType<File>()
      .asyncMap((f) async => (f, await f.lastModified()))
      .toList();
  recentWithLastModified.sort((a, b) => b.$2.compareTo(a.$2));

  // If there are >10 decks, delete the oldest.
  while (recentWithLastModified.length > 10) {
    final oldest = recentWithLastModified.removeLast();
    await oldest.$1.delete();
  }

  return File(outputPath).uri;
}

/// Returns all auto-saved JSON decks.
Future<List<(Deck, DateTime)>> fetchAutoSaves() async {
  final recentPath = await _recentPath;

  // Retrieve all decks saved, sorted by last modified.
  final recentWithLastModified = await Directory(recentPath)
      .list()
      .whereType<File>()
      .asyncMap((f) async => (f, await f.lastModified()))
      .toList();
  recentWithLastModified.sort((a, b) => b.$2.compareTo(a.$2));

  // Parse them all (it's only <=10).
  return Future.wait(recentWithLastModified.map((recent) async {
    final json = jsonDecode(
      await recent.$1.readAsString(),
    ) as Map<String, Object?>;
    return (Deck.fromJson(json, uri: recent.$1.uri), recent.$2);
  }));
}

/// Export a deck to a file.
Future<void> export(Deck deck) async {
  // Convert the deck to a (pretty-printed) JSON string.
  final output = const JsonEncoder.withIndent('  ').convert(deck.toJson());
  String fileName;
  if (!deck.autoSaved && deck.uri?.scheme == 'file') {
    fileName = deck.uri!.toFilePath();
  } else {
    fileName = deck.suggestedFileName;
    // Pick an output file.
    if (Platform.isAndroid || Platform.isIOS) {
      // Get a temporary file path.
      final tmpDir = Directory.systemTemp.createTempSync();
      final tmpFile = File(p.join(tmpDir.path, fileName));
      await tmpFile.writeAsString(output);
      await CRFileSaver.saveFileWithDialog(
        SaveFileDialogParams(
          sourceFilePath: tmpFile.path,
          destinationFileName: fileName,
        ),
      );
      return;
    }

    final name = await FilePicker.platform.saveFile(
      fileName: fileName,
      allowedExtensions: ['json'],
      dialogTitle: 'Export Deck',
      type: FileType.custom,
    );

    // User cancelled.
    if (name == null) {
      return;
    }

    fileName = name;
  }

  // Write the file.
  await File(fileName).writeAsString(output);
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
