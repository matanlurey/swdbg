import 'package:flutter/material.dart';
import 'package:swdbg_log_app/src/widgets/deck_list_view.dart';

import '/src/models/game.dart';
import '/src/widgets/add_card_dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_faction == null) {
      body = Scaffold(
        body: FactionPicker(
          onFactionSelected: (faction) {
            setState(() {
              _faction = faction;
            });
          },
        ),
      );
    } else {
      body = Center(
        child: _PlayingAs(faction: _faction!),
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
  });

  /// The faction the user is playing as.
  final Faction faction;

  @override
  State<StatefulWidget> createState() => _PlayingAsState();
}

final class _PlayingAsState extends State<_PlayingAs> {
  final deck = <GalaxyCard>[];

  @override
  void initState() {
    super.initState();
    switch (widget.faction) {
      case Faction.rebel:
        deck.addAll(GalaxyCard.rebelStarter);
      case Faction.imperial:
        deck.addAll(GalaxyCard.imperialStarter);
      case Faction.neutral:
        throw UnsupportedError('Cannot play as neutral faction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${deck.length} Cards'),
          leading: Padding(
            child: SizedBox(
              height: 40,
              width: 40,
              child: FactionIcon(faction: widget.faction),
            ),
            padding: const EdgeInsets.all(8),
          ),
          leadingWidth: 40,
        ),
        floatingActionButton: FloatingActionButton(
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
        body: DeckListView(
          deck: deck,
          onCardRemoved: (card) {
            setState(() {
              deck.remove(card);
            });
          },
        ));
  }
}
