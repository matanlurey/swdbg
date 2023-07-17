import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '/src/models/game.dart';
import '/src/widgets/add_card_dialog.dart';
import '/src/widgets/deck_list_view.dart';
import '/src/widgets/deck_summary_grid.dart';
import '/src/widgets/faction_icon.dart';
import '/src/widgets/faction_picker.dart';

void main() {
  runApp(const LogApp());
}

/// Main shell of the app.
final class LogApp extends StatefulWidget {
  /// Create a new log app.
  const LogApp();

  @override
  State<StatefulWidget> createState() => _LogAppState();
}

final class _LogAppState extends State<LogApp> {
  Faction? _faction;
  late List<GalaxyCard> _initialDeck;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_faction == null) {
      body = Scaffold(
        body: FactionPicker(
          onFactionSelected: (faction, initialDeck) {
            setState(() {
              _faction = faction;
              _initialDeck = initialDeck;
            });
          },
        ),
      );
    } else {
      body = Center(
        child: _PlayingAs(
          faction: _faction!,
          initialDeck: _initialDeck,
          onReset: () {
            setState(() {
              _faction = null;
            });
          },
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: body,
    );
  }
}

final class _PlayingAs extends StatefulWidget {
  /// Create a new playing as widget.
  const _PlayingAs({
    required this.faction,
    required this.onReset,
    this.initialDeck,
  });

  /// The faction the user is playing as.
  final Faction faction;

  /// The initial deck to start with.
  final List<GalaxyCard>? initialDeck;

  /// Function to call if the user wants to reset their deck.
  final VoidCallback onReset;

  @override
  State<StatefulWidget> createState() => _PlayingAsState();
}

final class _PlayingAsState extends State<_PlayingAs> {
  final deck = <GalaxyCard>[];

  @override
  void initState() {
    super.initState();
    deck.addAll(widget.initialDeck ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: widget.faction.color,
            actions: [
              // Export the deck.
              PopupMenuButton(itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: const Text('Export'),
                    value: 'export',
                    onTap: () async {
                      await _exportDeck(widget.faction, deck);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Reset'),
                    value: 'reset',
                    onTap: widget.onReset,
                  ),
                ];
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${deck.length} Cards'),
              background: Opacity(
                opacity: 0.3,
                child: Padding(
                  child: FactionIcon(faction: widget.faction),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ),
          ),
          DeckSummaryGrid(
            deck: deck,
          ),
          DeckListView(
            deck: deck,
            onCardRemoved: (card) {
              setState(() {
                deck.remove(card);
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.faction.color,
        onPressed: () async {
          // Open a dialog to add a card to the deck.
          await showDialog<void>(
            context: context,
            builder: (_) {
              return AddCardDialog(
                faction: widget.faction,
                onCardAdded: (card) {
                  setState(() {
                    deck.add(card);
                  });
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _exportDeck(Faction faction, List<GalaxyCard> deck) async {
  // Convert the deck to a (pretty) JSON string.
  final output = JsonEncoder.withIndent('  ').convert({
    'faction': faction.name,
    'deck': deck.map((c) => c.title).toList(),
  });

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
