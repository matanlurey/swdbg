import 'package:flutter/material.dart';

import '/src/models.dart' hide Card;

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
          value: 5 * summary.attack / deck.length,
        ),
        _DeckSummaryGridItem(
          label: 'Hit Points',
          value: 5 * summary.hitPoints / deck.length,
        ),
        _DeckSummaryGridItem(
          label: 'Resources',
          value: 5 * summary.resources / deck.length,
        ),
        _DeckSummaryGridItem(
          label: 'Force',
          value: 5 * summary.force / deck.length,
        ),
      ],
    );
  }
}

final class _DeckSummaryGridItem extends StatelessWidget {
  const _DeckSummaryGridItem({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text('per turn'),
        trailing: Text(value.isNaN ? '0.00' : value.toStringAsFixed(2)),
      ),
    );
  }
}
