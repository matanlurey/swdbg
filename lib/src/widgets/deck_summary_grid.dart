part of '../widgets.dart';

/// Shows aggregate information about a deck.
///
/// Includes:
/// - Average attack per turn.
/// - Average defense per turn.
/// - Average resources per turn.
/// - Average force per turn.
final class DeckSummaryGrid extends StatelessWidget {
  /// Create a new deck summary grid.
  const DeckSummaryGrid({
    required this.deck,
  });

  /// The deck to summarize.
  final List<GalaxyCard> deck;

  @override
  Widget build(BuildContext context) {
    final summary = DeckSummary.fromDeck(deck);
    return SliverGrid.count(
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      children: [
        _DeckSummaryGridItem(
          label: 'Attack',
          value: summary.attack,
          deckLength: deck.length,
        ),
        _DeckSummaryGridItem(
          label: 'Hit Points',
          value: summary.hitPoints,
          deckLength: deck.length,
        ),
        _DeckSummaryGridItem(
          label: 'Resources',
          value: summary.resources,
          deckLength: deck.length,
        ),
        _DeckSummaryGridItem(
          label: 'Force',
          value: summary.force,
          deckLength: deck.length,
        ),
      ],
    );
  }
}

final class _DeckSummaryGridItem extends StatelessWidget {
  const _DeckSummaryGridItem({
    required this.label,
    required this.value,
    required this.deckLength,
    this.isPriority = false,
    this.isForceWithYou = false,
  });

  final String label;
  final AttributeSummary value;
  final int deckLength;
  final bool isPriority;
  final bool isForceWithYou;

  @override
  Widget build(BuildContext context) {
    final value = this.value.baseTotal * 5 / deckLength;
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text('per turn'),
        trailing: Text(value.isNaN ? '0.00' : value.toStringAsFixed(2)),
      ),
    );
  }
}
