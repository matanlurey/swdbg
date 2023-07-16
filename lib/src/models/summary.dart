final class DeckSummary {
  /// Average amount of attack per turn.
  final double attack;

  /// Average amount of defense per turn.
  final double defense;

  /// Average amount of resources per turn.
  final double resources;

  /// Average amount of force per turn.
  final double force;

  /// Create a new deck summary.
  const DeckSummary({
    required this.attack,
    required this.defense,
    required this.resources,
    required this.force,
  });

  /// Create a new deck summary from a deck.
}
