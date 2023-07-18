import 'package:flutter/material.dart';

import '/src/actions.dart';
import '/src/models.dart';
import '/src/widgets/add_card_dialog.dart';
import '/src/widgets/deck_list_view.dart';
import '/src/widgets/deck_picker.dart';
import '/src/widgets/deck_summary_grid.dart';
import '/src/widgets/faction_icon.dart';

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
  Deck? _deck;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_deck == null) {
      body = Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: DeckPicker((deck) {
              setState(() {
                _deck = deck;
              });
            }),
          ),
        ),
      );
    } else {
      body = Center(
        child: _PlayingAs(
          initialDeck: _deck!,
          onReset: () {
            setState(() {
              _deck = null;
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
    required this.onReset,
    required this.initialDeck,
  });

  /// The initial deck to start with.
  final Deck initialDeck;

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
    deck.addAll(widget.initialDeck.cards);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: widget.initialDeck.faction.color,
            actions: [
              // Export the deck.
              PopupMenuButton(itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: const Text('Export'),
                    value: 'export',
                    onTap: () async {
                      await export(Deck(
                        faction: widget.initialDeck.faction,
                        cards: deck,
                      ));
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
                  child: FactionIcon(faction: widget.initialDeck.faction),
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
        backgroundColor: widget.initialDeck.faction.color,
        onPressed: () async {
          // Open a dialog to add a card to the deck.
          await showDialog<void>(
            context: context,
            builder: (_) {
              return AddCardDialog(
                faction: widget.initialDeck.faction,
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
