import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '/src/models/game.dart';
import '/src/widgets/faction_icon.dart';

/// A menu that presents the user with a choice of factions.
final class FactionPicker extends StatelessWidget {
  /// Create a new faction picker.
  const FactionPicker({
    required this.onFactionSelected,
  });

  /// Called when the user selects a faction.
  final void Function(Faction, List<GalaxyCard>) onFactionSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              onFactionSelected(Faction.rebel, GalaxyCard.rebelStarter);
            },
            icon: SizedBox(
              height: 16,
              width: 16,
              child: FactionIcon(faction: Faction.rebel),
            ),
            label: const Text('Rebel Alliance'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Faction.rebel.color),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              onFactionSelected(Faction.imperial, GalaxyCard.imperialStarter);
            },
            icon: SizedBox(
              height: 16,
              width: 16,
              child: FactionIcon(faction: Faction.imperial),
            ),
            label: const Text('Galactic Empire'),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Faction.imperial.color),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (Random().nextBool()) {
                onFactionSelected(Faction.rebel, GalaxyCard.rebelStarter);
              } else {
                onFactionSelected(Faction.imperial, GalaxyCard.imperialStarter);
              }
            },
            icon: Icon(Icons.casino),
            label: const Text('Random'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Faction.neutral.color),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final (faction, deck) = await _importDeck();
              if (faction != null) {
                onFactionSelected(faction, deck);
              }
            },
            icon: Icon(Icons.file_upload),
            label: const Text('Import'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Faction.neutral.color),
            ),
          ),
        ],
      ),
    );
  }
}

Future<(Faction?, List<GalaxyCard>)> _importDeck() async {
  // Pick an input file.
  final name = await FilePicker.platform.pickFiles(
    allowedExtensions: ['json'],
    dialogTitle: 'Import Deck',
    type: FileType.custom,
  );

  if (name == null) {
    return (null, const <GalaxyCard>[]);
  }

  // Read the JSON file.
  final contents = await File(name.files.single.path!).readAsString();
  final json = jsonDecode(contents) as Map<String, dynamic>;

  // Parse the faction.
  final faction = Faction.values.firstWhere(
    (f) => f.name == json['faction'],
    orElse: () => throw FormatException('Invalid faction'),
  );

  // Parse the deck.
  final deck = (json['deck'] as List<dynamic>)
      .map((title) => GalaxyCard.allCards.firstWhere(
            (c) => c.title == title,
            orElse: () => throw FormatException('Invalid card'),
          ))
      .toList();

  return (faction, deck);
}
