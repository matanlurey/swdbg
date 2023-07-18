part of '../models.dart';

/// A deck of cards.
@immutable
final class Deck {
  /// The faction this deck is for.
  final Faction faction;

  /// The cards in this deck.
  final List<GalaxyCard> cards;

  /// Create a new deck.
  const Deck({
    required this.faction,
    required this.cards,
  });

  /// Create a new deck from a JSON map.
  factory Deck.fromJson(Map<String, Object?> json) {
    final faction = json['faction'] as String?;
    if (faction == null) {
      throw FormatException('Missing faction');
    }
    final cards = json['cards'] as List<Object?>?;
    if (cards == null) {
      throw FormatException('Missing cards');
    }
    return Deck(
      faction: Faction.values.firstWhere((f) => f.name == faction),
      cards: cards
          .cast<String>()
          .map((name) => CardDefinitions.instance.allGalaxy
              .firstWhere((e) => e.title == name))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Deck || faction != other.faction) {
      return false;
    }
    const unorderedEquals = UnorderedIterableEquality<GalaxyCard>();
    return unorderedEquals.equals(cards, other.cards);
  }

  @override
  int get hashCode => Object.hash(faction, Object.hashAllUnordered(cards));

  /// Return a JSON map representing this deck.
  Map<String, Object?> toJson() {
    return {
      'faction': faction.name,
      'cards': cards.map((c) => c.title).toList(),
    };
  }

  @override
  String toString() => 'Deck($faction, ${cards.length} cards)';
}
