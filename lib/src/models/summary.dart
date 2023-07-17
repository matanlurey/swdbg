import '/src/models/game.dart';

/// Contains aggregate information about a deck.
final class DeckSummary {
  /// Total amount of attack.
  final double attack;

  /// Total amount of hit points.
  final double hitPoints;

  /// Total amount of resources.
  final double resources;

  /// Total amount of force.
  final double force;

  /// Create a new deck summary.
  const DeckSummary({
    required this.attack,
    required this.hitPoints,
    required this.resources,
    required this.force,
  });

  /// Create a new deck summary from a deck.
  factory DeckSummary.fromDeck(Iterable<GalaxyCard> deck) {
    var attack = 0.0;
    var hitPoints = 0.0;
    var resources = 0.0;
    var force = 0.0;
    for (final card in deck) {
      attack += card.attack;
      hitPoints += card.hitPoints ?? 0;
      resources += card.resources;
      force += card.force;
    }
    return DeckSummary(
      attack: attack,
      hitPoints: hitPoints,
      resources: resources,
      force: force,
    );
  }
}
