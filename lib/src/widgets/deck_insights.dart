part of '../widgets.dart';

/// ...
final class ExperimentalDeckInsights extends StatelessWidget {
  /// Deck to analyze.
  final Deck deck;

  /// ...
  const ExperimentalDeckInsights({
    required this.deck,
  });

  static final _attackIcon = SvgPicture.asset(
    'assets/attack.svg',
    height: 24,
    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
  );

  static final _resourcesIcon = SvgPicture.asset(
    'assets/resources.svg',
    height: 24,
    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
  );

  static final _forceIcon = SvgPicture.asset(
    'assets/force.svg',
    height: 24,
    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
  );

  static final _hitPointsIcon = Icon(
    Icons.health_and_safety,
    color: Colors.grey,
    size: 24,
  );

  static final _healingIcon = Icon(
    Icons.healing,
    color: Colors.grey,
    size: 24,
  );

  double _compute(AttributeSummary value) {
    return value.maximum * 5 / deck.cards.length;
  }

  @override
  Widget build(BuildContext context) {
    final summary = DeckSummary.fromDeck(deck.cards);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InsightAttribute(
                  icon: _attackIcon,
                  value: _compute(summary.attack),
                ),
                _InsightAttribute(
                  icon: _resourcesIcon,
                  value: _compute(summary.resources),
                ),
                _InsightAttribute(
                  icon: _forceIcon,
                  value: _compute(summary.force),
                ),
                _InsightAttribute(
                  icon: _hitPointsIcon,
                  value: _compute(summary.hitPoints),
                ),
                _InsightAttribute(
                  icon: _healingIcon,
                  value: _compute(summary.repair),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _InsightAttribute extends StatelessWidget {
  final Widget icon;
  final double value;

  const _InsightAttribute({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: icon,
      label: Text(
        value.toStringAsFixed(1),
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
