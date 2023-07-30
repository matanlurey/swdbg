part of '../views.dart';

/// How to sort a deck.
enum DeckSort {
  /// Sort by most expensive.
  mostExpensive,

  /// Sort by least expensive.
  leastExpensive,

  /// Sort alphabetically.
  alphabetical;

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

  /// The comparator to use for this sort.
  Comparator<GalaxyCard> get comparator {
    switch (this) {
      case DeckSort.mostExpensive:
        return _compareExpensive;
      case DeckSort.leastExpensive:
        return _compareCheapest;
      case DeckSort.alphabetical:
        return _compareAlphabetical;
    }
  }
}

/// A view that displays a deck.
final class DeckView extends StatefulWidget {
  /// The initial deck of cards.
  final Deck initialDeck;

  /// The initial sorting method.
  final DeckSort initialSort;

  /// Create a new deck view.
  const DeckView({
    required this.initialDeck,
    this.initialSort = DeckSort.mostExpensive,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _DeckViewState();
}

final class _DeckViewState extends State<DeckView> {
  final deck = <GalaxyCard>[];
  late DeckSort sorter;

  @override
  void initState() {
    super.initState();
    deck.addAll(widget.initialDeck.cards);
    sorter = widget.initialSort;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If the deck has only starter cards, don't prompt the user.
        if (deck.every((c) => c.isStarter)) {
          return true;
        }

        // Prompt the user to confirm that they want to leave the deck.
        final result = await showDialog<bool>(
          context: context,
          builder: (_) => _ConfirmWillPop(),
        );
        return result ?? false;
      },
      child: Theme(
        data: widget.initialDeck.faction.theme,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // Navigate to the add card screen.
              final card = await Navigator.of(context).push<GalaxyCard>(
                MaterialPageRoute(
                  builder: (_) => Theme(
                    data: widget.initialDeck.faction.theme,
                    child: CatalogView.selectCard(
                      catalog: CardDefinitions.instance.allGalaxy,
                      initiallyExcludeFaction:
                          widget.initialDeck.faction.opposing,
                      initiallyHideStarterCards: true,
                    ),
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
          body: CustomScrollView(
            slivers: [
              _DeckViewAppBar(
                faction: widget.initialDeck.faction,
                cards: deck,
                sorter: sorter,
                onSortChanged: (s) {
                  setState(() {
                    sorter = s;
                  });
                },
              ),
              DeckInsights(
                deck: deck,
              ),
              _DeckViewCardList(
                cards: () {
                  return deck.toList()..sort(sorter.comparator);
                }(),
                onCardAdded: (card) {
                  setState(() {
                    deck.add(card);
                  });
                },
                onCardRemoved: (card, index) {
                  setState(() {
                    // If index is set, remove the Nth appearance of the card.
                    for (var i = 0; i < deck.length; i++) {
                      if (deck[i].title == card.title) {
                        if (index == 0) {
                          deck.removeAt(i);
                          break;
                        }
                        index--;
                      }
                    }
                  });
                },
              ),
              // Add some padding so the FAB doesn't cover the last card.
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Used as an alert dialog to confirm that the user wants to leave the deck.
final class _ConfirmWillPop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('You have unsaved changes.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Discard'),
        ),
      ],
    );
  }
}

final class _DeckViewAppBar extends StatelessWidget {
  /// The faction to display.
  final Faction faction;

  /// The cards in the deck.
  final List<GalaxyCard> cards;

  /// How to sort the deck.
  final DeckSort sorter;

  /// Calld to change the sort.
  final void Function(DeckSort) onSortChanged;

  const _DeckViewAppBar({
    required this.faction,
    required this.cards,
    required this.sorter,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('${cards.length} Cards'),
        centerTitle: true,
        background: Opacity(
          opacity: 0.3,
          child: Padding(
            child: FactionIcon(faction: faction),
            padding: const EdgeInsets.all(8),
          ),
        ),
      ),
      actions: [
        // Sort
        PopupMenuButton(
          itemBuilder: (_) {
            return [
              CheckedPopupMenuItem(
                child: const Text('Most Expensive'),
                value: DeckSort.mostExpensive,
                checked: sorter == DeckSort.mostExpensive,
              ),
              CheckedPopupMenuItem(
                child: const Text('Least Expensive'),
                value: DeckSort.leastExpensive,
                checked: sorter == DeckSort.leastExpensive,
              ),
              CheckedPopupMenuItem(
                child: const Text('Alphabetical'),
                value: DeckSort.alphabetical,
                checked: sorter == DeckSort.alphabetical,
              ),
            ];
          },
          onSelected: onSortChanged,
          icon: const Icon(Icons.sort),
        ),

        // Export.
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () async {
            await export(Deck(cards: cards, faction: faction));
          },
        ),
      ],
    );
  }
}

final class _DeckViewCardList extends StatelessWidget {
  /// The cards to display.
  final List<GalaxyCard> cards;

  /// When a card is added.
  final void Function(GalaxyCard) onCardAdded;

  /// When a card is removed.
  final void Function(GalaxyCard, int) onCardRemoved;

  const _DeckViewCardList({
    required this.cards,
    required this.onCardAdded,
    required this.onCardRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return CatalogSliverList(
      cards: cards,
      onCardDismissed: onCardRemoved,
      onCardSelected: (card) async {
        final action = await PreviewCardSheet.showAndCheckAdd(
          context,
          card,
          actions: {
            PreviewCardAction.duplicate,
            PreviewCardAction.exile,
          },
        );
        if (action == PreviewCardAction.duplicate) {
          onCardAdded(card);
        } else if (action == PreviewCardAction.exile) {
          onCardRemoved(card, 0);
        }
      },
    );
  }
}
