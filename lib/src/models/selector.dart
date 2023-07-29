part of '../models.dart';

/// Where a card could be.
enum CardLocation {
  /// The current card.
  currentCard,

  /// The player's deck.
  currentPlayersDeck,

  /// The player's hand.
  currentPlayersHand,

  /// The player's discard pile.
  currentPlayersDiscardPile,

  /// The player's play area.
  currentPlayersPlayArea,

  /// The opponent's hand.
  opponentsHand,

  /// The opponent's discard pile.
  opponentsPlayArea,

  /// Galaxy row.
  galaxyRow,

  /// Galaxy row's discard pile.
  galaxyRowDiscardPile,
}

/// A definition of what card(s) are eligible to be selected.
sealed class CardSelector {
  // ignore: public_member_api_docs
  const CardSelector();

  /// Create a selector that matches a specific card by title.
  factory CardSelector.byTitle(String title) = CardTitleSelector._;

  /// Create a selector that matches cards with at least one of the traits.
  factory CardSelector.byTraits(Set<Trait> traits) = CardTraitSelector._;

  /// Create a selector that matches unique cards.
  factory CardSelector.unique() = CardUniqueSelector._;

  /// Create a selector that matches capital ships.
  factory CardSelector.capitalShips() = CardCapitalShipSelector._;

  /// Create a selector that matches bases.
  factory CardSelector.bases() = CardBaseSelector._;

  /// Create a selector that matches a faction.
  factory CardSelector.faction(Faction faction) = FactionSelector._;

  /// Creates a new selector that matches either selector.
  CardSelector or(CardSelector other) {
    return CardSelectorOr._({this, other});
  }
}

/// A selector that matches either selector.
final class CardSelectorOr extends CardSelector {
  /// The selectors to match.
  final Set<CardSelector> selectors;

  const CardSelectorOr._(this.selectors);

  @override
  CardSelector or(CardSelector other) {
    return CardSelectorOr._({
      ...selectors,
      other,
    });
  }
}

/// A selector that matches a specific card by title
final class CardTitleSelector extends CardSelector {
  /// The title of the card to match.
  final String title;

  const CardTitleSelector._(this.title);
}

/// A selector that matches cards with at least one of the traits.
final class CardTraitSelector extends CardSelector {
  /// The traits to match at least one of.
  final Set<Trait> traits;

  const CardTraitSelector._(this.traits);
}

/// A selector that matches unique cards.
final class CardUniqueSelector extends CardSelector {
  const CardUniqueSelector._();
}

/// A selector that mathches bases.
final class CardBaseSelector extends CardSelector {
  const CardBaseSelector._();
}

/// A selector that matches capital ships.
final class CardCapitalShipSelector extends CardSelector {
  const CardCapitalShipSelector._();
}

/// A selector that matches a faction.
final class FactionSelector extends CardSelector {
  /// The faction to match.
  final Faction faction;

  const FactionSelector._(this.faction);
}
