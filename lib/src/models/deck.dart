part of '../models.dart';

/// A deck of cards.
@immutable
final class Deck {
  /// The faction this deck is for.
  final Faction faction;

  /// The cards in this deck.
  final List<GalaxyCard> cards;

  /// Whether this deck was auto-saved.
  final bool autoSaved;

  /// Canonical URI for this deck, or `null` if it was not saved/loaded.
  final Uri? uri;

  /// Create a new deck.
  const Deck({
    required this.faction,
    required this.cards,
    this.uri,
    this.autoSaved = false,
  });

  /// Create a new deck from a JSON map.
  factory Deck.fromJson(Map<String, Object?> json, {Uri? uri}) {
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
      uri: uri,
    );
  }

  /// Create a new deck with the given URI and auto-saved status.
  Deck withUri(Uri uri, {bool? autoSaved}) {
    return Deck(
      faction: faction,
      cards: cards,
      uri: uri,
      autoSaved: autoSaved ?? this.autoSaved,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Deck || faction != other.faction || uri != other.uri) {
      return false;
    }
    const unorderedEquals = UnorderedIterableEquality<GalaxyCard>();
    return unorderedEquals.equals(cards, other.cards);
  }

  @override
  int get hashCode => Object.hash(faction, uri, Object.hashAllUnordered(cards));

  /// Return a JSON map representing this deck.
  ///
  /// Note this does not include the URI.
  Map<String, Object?> toJson() {
    return {
      'faction': faction.name,
      'cards': cards.map((c) => c.title).toList(),
    };
  }

  @override
  String toString() {
    return 'Deck($faction, '
        '${cards.length} cards, '
        'uri: <$uri> (auto: $autoSaved)})';
  }
}
