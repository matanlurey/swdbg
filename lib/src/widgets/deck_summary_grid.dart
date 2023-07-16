import 'package:flutter/material.dart';

import '/src/models/game.dart';

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
    return SliverGrid.count(
      crossAxisCount: 2,
      childAspectRatio: 2,
      children: [
        _DeckSummaryGridItem(
          label: 'Attack',
          value: 0,
        ),
        _DeckSummaryGridItem(
          label: 'Defense',
          value: 0,
        ),
        _DeckSummaryGridItem(
          label: 'Resources',
          value: 0,
        ),
        _DeckSummaryGridItem(
          label: 'Force',
          value: 0,
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
        subtitle: Text(value.toStringAsFixed(2)),
      ),
    );
  }
}
