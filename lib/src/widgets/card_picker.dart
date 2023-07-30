part of '../widgets.dart';

/// A menu that presents the user with a choice of cards to add to their deck.
final class CardPicker extends StatelessWidget {
  /// The user's faction.
  ///
  /// If specified, cards from the opposing faction are not shown.
  final Faction? faction;

  /// Called when the user selects a card.
  final ValueChanged<GalaxyCard?> onCardSelected;

  /// Unique cards that cannot be added to the deck.
  final Set<GalaxyCard> uniqueCards;

  /// Create a new card picker.
  const CardPicker({
    required this.onCardSelected,
    required this.faction,
    required this.uniqueCards,
  });

  @override
  Widget build(BuildContext context) {
    Iterable<GalaxyCard> filter = CardDefinitions.instance.allGalaxy;

    // If a faction is specified, filter out cards from the opposing faction.
    if (faction != null) {
      final opposing = faction!.opposing;
      filter = filter.where((card) => card.faction != opposing);
    }

    // Next, filter out any starter cards.
    filter = filter.where((card) => !card.isStarter);

    /// Next, filter out any unique cards.
    filter = filter.where((card) => !uniqueCards.contains(card));

    // Finally, sort the cards by name.
    final cards = filter.toList()..sort((a, b) => a.title.compareTo(b.title));

/*

          SegmentedButton(
            segments: [
              ButtonSegment(
                label: Text('0 - 2'),
                value: (0, 2),
              ),
              ButtonSegment(
                label: Text('3 - 5'),
                value: (3, 5),
              ),
              ButtonSegment(
                label: Text('6+'),
                value: (6, 8),
              ),
            ],
            selected: {(0, 2)},
            onSelectionChanged: (s) {
              // TODO: Implement.
            },
          ),
          */
    return SizedBox(
      width: 300,
      child: _ExperimentalGridSelector(
        cards: cards,
        onCardSelected: onCardSelected,
      ),
    );
  }
}

final class _ExperimentalGridSelector extends StatelessWidget {
  final List<GalaxyCard> cards;
  final ValueChanged<GalaxyCard> onCardSelected;

  const _ExperimentalGridSelector({
    required this.cards,
    required this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      children: cards.map((card) {
        return InkWell(
          onTap: () => onCardSelected(card),
          child: Card(
            color: card.faction.theme.primaryColor,
            child: Center(
              child: Text(
                card.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
