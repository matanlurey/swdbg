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
  static final _iconsByName = <String, Widget>{
    'attack': SvgPicture.asset(
      'assets/attack.svg',
      width: 32,
      height: 32,
      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    'resources': SvgPicture.asset(
      'assets/resources.svg',
      width: 32,
      height: 32,
      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    'force': SvgPicture.asset(
      'assets/force.svg',
      width: 32,
      height: 32,
      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
    ),
    'hit points': Icon(Icons.health_and_safety),
  };

  const _DeckSummaryGridItem({
    required this.label,
    required this.value,
    required this.deckLength,
  });

  final String label;
  final AttributeSummary value;
  final int deckLength;

  @override
  Widget build(BuildContext context) {
    var min = value.baseTotal * 5 / deckLength;
    var max =
        (value.baseTotal + value.ifAbilitySelected + value.ifConditionIsMet) *
            5 /
            deckLength;
    if (min.isNaN) {
      min = 0;
    }
    if (max.isNaN) {
      max = 0;
    }
    return Card(
      child: ListTile(
        leading: _iconsByName[label.toLowerCase()] ?? SizedBox(width: 32),
        title: Text(
          '${min.toStringAsFixed(1)} - ${max.toStringAsFixed(1)}',
        ),
        subtitle: Text(label),
      ),
    );
  }
}
