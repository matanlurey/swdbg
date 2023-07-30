import 'package:flutter/material.dart';

import '/src/actions.dart';
import '/src/models.dart';
import '/src/themes.dart';
import '/src/views.dart';
import '/src/widgets.dart';

void main() async {
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
            height: 500,
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
        child: Theme(
          data: _deck!.faction.theme,
          child: _PlayingAs(
            initialDeck: _deck!,
            onReset: () {
              setState(() {
                _deck = null;
              });
            },
          ),
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

enum _SortBy {
  expensive(_compareExpensive),
  chapest(_compareCheapest),
  alphabetical(_compareAlphabetical);

  static int _compareExpensive(GalaxyCard a, GalaxyCard b) {
    // If price is the same, sort by title.
    if (a.cost == b.cost) {
      return a.title.compareTo(b.title);
    }
    return b.cost.compareTo(a.cost);
  }

  static int _compareCheapest(GalaxyCard a, GalaxyCard b) {
    // If price is the same, sort by title.
    if (a.cost == b.cost) {
      return a.title.compareTo(b.title);
    }
    return a.cost.compareTo(b.cost);
  }

  static int _compareAlphabetical(GalaxyCard a, GalaxyCard b) {
    return a.title.compareTo(b.title);
  }

  /// The sorter to use for this sort by.
  final Comparator<GalaxyCard> sorter;

  const _SortBy(this.sorter);
}

final class _PlayingAsState extends State<_PlayingAs> {
  final deck = <GalaxyCard>[];
  var sorter = _SortBy.expensive;

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
                  PopupMenuItem(
                    child: const Text('About'),
                    value: 'cancel',
                    onTap: () {
                      // https://github.com/flutter/flutter/issues/87766
                      // Without this, the onTap closes the dialog!
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await showDialog<void>(
                          context: context,
                          builder: (_) => ChangelogDialog(),
                        );
                      });
                    },
                  ),
                ];
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${deck.length} Cards'),
              centerTitle: true,
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
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: SegmentedButton(
                segments: [
                  ButtonSegment(
                    label: Text('Expensive'),
                    value: _SortBy.expensive,
                  ),
                  ButtonSegment(
                    label: Text('Cheapest'),
                    value: _SortBy.chapest,
                  ),
                  ButtonSegment(
                    label: Text('ABC'),
                    value: _SortBy.alphabetical,
                  ),
                ],
                selected: {sorter},
                onSelectionChanged: (s) {
                  setState(() {
                    sorter = s.single;
                  });
                },
              ),
            ),
          ),
          DeckListView(
            deck: deck,
            sortBy: sorter.sorter,
            onCardRemoved: (card) {
              setState(() {
                deck.remove(card);
              });
            },
            onCardDuplicated: (card) {
              setState(() {
                deck.add(card);
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the add card screen.
          final card = await Navigator.of(context).push<GalaxyCard>(
            MaterialPageRoute(
              builder: (_) => CatalogView.selectCard(
                catalog: CardDefinitions.instance.allGalaxy,
                initiallyExcludeFaction: widget.initialDeck.faction.opposing,
                initiallyHideStarterCards: true,
              ),
            ),
          );
          if (card != null) {
            setState(() {
              deck.add(card);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
