part of '../models.dart';

/// A card-specific ability.
@immutable
sealed class Ability {
  /// Create an ability.
  const Ability();

  /// Creates an ability that allows the player to pick current or [other].
  Ability or(Ability other) => ChooseAbility._([this, other]);

  /// Gain the specified amount of attack.
  ///
  /// Amount must be a positive number.
  factory Ability.gainAttack(int amount) = GainAttackAbility._;

  /// Gain the specified amount of resources.
  ///
  /// Amount must be a positive number.
  factory Ability.gainResources(int amount) = GainResourcesAbility._;

  /// Gain the specified amount of Force.
  ///
  /// Amount must be a positive number.
  factory Ability.gainForce(int amount) = GainForceAbility._;

  /// Repair the base for the specified amount.
  ///
  /// Amount must be a positive number.
  factory Ability.repairBase(int amount) = RepairBaseAbility._;

  /// Draw a card, or card(s) into the player's hand.
  ///
  /// Amount must be a positive number; defaults to 1.
  ///
  /// And optionally if a condition is met, increase the amount by 1.
  factory Ability.drawCard({
    int amount,
    Condition? ifConditionBonus,
    Ability? ifMetApplyAbility,
  }) = DrawCardAbility._;

  /// Add a card from a location to the player's hand.
  const factory Ability.addCard({
    required CardLocation from,
    CardSelector? selector,
  }) = AddCardAbility._;

  /// Discard a card, or card(s), from a location.
  ///
  /// Amount must be a positive number; defaults to 1.
  ///
  /// Optionally if the Force is with you, at random.
  factory Ability.discardCard({
    required CardLocation from,
    int amount,
    bool ifForceIsWithYouAtRandom,
  }) = DiscardCardAbility._;

  /// Apply the specified ability to each matching card in play.
  const factory Ability.applyForEach({
    required CardSelector selector,
    required Ability ability,
  }) = ApplyForEachAbility._;

  /// Apply the specified ability when a condition is met.
  const factory Ability.applyWhen({
    required Condition condition,
    required Ability ability,
  }) = ApplyWhenAbility._;

  /// Purchase a card for free from the galaxy row.
  ///
  /// The card is either added to the player's hand (and must be exiled at the
  /// end of the turn), or added to the player's deck (on top of the deck if
  /// the "Force is with you").
  const factory Ability.purchaseCardForFree({
    required CardSelector selector,
    required PurchaseCardLocation to,
  }) = PurchaseCardAbility._;

  /// Purchase a card from the galaxy row discard pile.
  const factory Ability.purchaseCardFromGalaxyRowDiscardPile() =
      PurchaseCardFromGalaxyRowDiscardAbility._;

  /// Look at the top card of the galaxy deck.
  ///
  /// If the "Force is with you", you may swap that card with a card from the
  /// galaxy row.
  const factory Ability.lookAtTopGalaxyCard() = LookAtTopGalaxyCardAbility._;

  /// Reveal the top card of the galaxy deck.
  ///
  /// - If it matches the specified selector, apply the specified ability.
  /// - If it is an enemy card, discard it.
  const factory Ability.revealTopGalaxyCard({
    required CardSelector andIfMatches,
    required Ability thenApply,
  }) = RevealTopGalaxyCardAbility._;

  /// For each defeated base, apply the specified ability.
  const factory Ability.applyForEachDefeatedBase({
    required Ability ability,
  }) = ApplyForEachDefeatedBaseAbility._;

  /// Destroy a card in play (and optionally, in the galaxy row).
  const factory Ability.destroyCard({
    required CardSelector selector,
    required bool orInGalaxyRow,
  }) = DestroyCardAbility._;

  /// Look at your opponent's hand.
  ///
  /// If the Force is with you, place 1 card from their hand on top of their
  /// deck.
  const factory Ability.lookAtOpponentHand() = LookAtOpponentHandAbility._;

  /// Deal the provided amount of damage to a card that matches a selector.
  const factory Ability.dealDamage({
    required int amount,
    required CardSelector selector,
  }) = DealDamageAbility._;

  /// If you purchase this card, activate the specified ability.
  ///
  /// Optionally, if the force is with you, activate another ability.
  const factory Ability.activateIfPurchased({
    required Ability ability,
    Ability? andIfForceIsWithYou,
  }) = ActivateAbilityIfPurchasedAbility._;

  /// Exile a card from the specified location.
  ///
  /// Optionally provide an amount greater than 1 to exile multiple cards.
  factory Ability.exileCard({
    required Set<CardLocation> from,
    int amount,
  }) = ExileCardAbility._;

  /// Place a purchased card on top of your deck.
  const factory Ability.placePurchasedCardOnTopOfDeck() =
      PlacePurchasedCardOnTopOfDeckAbility._;
}

/// Choose one of the specified abilities to use.
final class ChooseAbility extends Ability {
  /// Possible abilities to use.
  final List<Ability> abilities;

  ChooseAbility._(this.abilities) {
    if (abilities.length < 2) {
      throw ArgumentError.value(
        abilities.length,
        'abilities',
        'must have >= 2',
      );
    }
  }

  @override
  Ability or(Ability other) {
    return ChooseAbility._([...abilities, other]);
  }
}

void _checkAmount(int amount) {
  if (amount < 0) {
    throw ArgumentError.value(amount, 'amount', 'must be positive');
  }
}

/// Gain the specified amount of attack.
final class GainAttackAbility extends Ability {
  /// The amount of attack to gain.
  final int amount;

  GainAttackAbility._(this.amount) {
    _checkAmount(amount);
  }
}

/// Gain the specified amount of resources.
final class GainResourcesAbility extends Ability {
  /// The amount of resources to gain.
  final int amount;

  GainResourcesAbility._(this.amount) {
    _checkAmount(amount);
  }
}

/// Gain the specified amount of Force.
final class GainForceAbility extends Ability {
  /// The amount of Force to gain.
  final int amount;

  GainForceAbility._(this.amount) {
    _checkAmount(amount);
  }
}

/// Repair the base for the specified amount.
final class RepairBaseAbility extends Ability {
  /// The amount to repair the base for.
  final int amount;

  RepairBaseAbility._(this.amount) {
    _checkAmount(amount);
  }
}

/// Draw 1+ card(s) from the specified location into the player's hand.
final class DrawCardAbility extends Ability {
  /// The number of cards to draw.
  final int amount;

  /// If the condition is met, increase the amount by 1.
  final Condition? ifConditionBonus;

  /// If the condition is met, apply the specified ability.
  final Ability? ifMetApplyAbility;

  DrawCardAbility._({
    this.amount = 1,
    this.ifConditionBonus,
    this.ifMetApplyAbility,
  }) {
    _checkAmount(amount);
  }
}

/// Add a card from a location to the player's hand.
final class AddCardAbility extends Ability {
  /// Where to add the card from.
  final CardLocation from;

  /// What card type to add.
  ///
  /// If `null`, any card type is allowed.
  final CardSelector? selector;

  const AddCardAbility._({
    required this.from,
    this.selector,
  });
}

/// Discard 1+ card(s) from a location.
final class DiscardCardAbility extends Ability {
  /// The number of cards to discard.
  final int amount;

  /// Where to discard the card(s) from.
  final CardLocation from;

  /// If the Force is with you, at random.
  final bool ifForceIsWithYouAtRandom;

  DiscardCardAbility._({
    required this.from,
    this.amount = 1,
    this.ifForceIsWithYouAtRandom = false,
  }) {
    _checkAmount(amount);
  }
}

/// Apply an ability to every card in your play area that matches the selector.
final class ApplyForEachAbility extends Ability {
  /// The selector to match cards with.
  final CardSelector selector;

  /// The ability to apply to each card.
  final Ability ability;

  const ApplyForEachAbility._({
    required this.selector,
    required this.ability,
  });
}

/// Apply an ability when a condition is met.
final class ApplyWhenAbility extends Ability {
  /// The condition to check.
  final Condition condition;

  /// The ability to apply when the condition is met.
  final Ability ability;

  const ApplyWhenAbility._({
    required this.condition,
    required this.ability,
  });
}

/// Where to add the card.
enum PurchaseCardLocation {
  /// Add the card to the player's hand (and exile at the end of the turn).
  handAndExileAtEndOfTurn,

  /// Add the card to the player's deck (on top if the "Force is with you").
  deckOnTopIfForceIsWithYou,
}

/// Purchase a card for free from the galaxy row.
///
/// The card is either added to the player's hand (and must be exiled at the
/// end of the turn), or added to the player's deck (on top of the deck if
/// the "Force is with you").
final class PurchaseCardAbility extends Ability {
  /// The selector to match cards with.
  final CardSelector selector;

  /// Where to add the card.
  final PurchaseCardLocation to;

  const PurchaseCardAbility._({
    required this.selector,
    required this.to,
  });
}

/// Look at the top card of the galaxy deck.
///
/// If the "Force is with you", you may swap that card with a card from the
/// galaxy row.
final class LookAtTopGalaxyCardAbility extends Ability {
  const LookAtTopGalaxyCardAbility._();
}

/// Reveal the top card of the galaxy deck.
///
/// - If it matches the specified selector, apply the specified ability.
/// - If it is an enemy card, discard it.
final class RevealTopGalaxyCardAbility extends Ability {
  /// The selector to match cards with.
  final CardSelector andIfMatches;

  /// The ability to apply when the condition is met.
  final Ability thenApply;

  const RevealTopGalaxyCardAbility._({
    required this.andIfMatches,
    required this.thenApply,
  });
}

/// For each defeated base, apply the specified ability.
final class ApplyForEachDefeatedBaseAbility extends Ability {
  /// The ability to apply.
  final Ability ability;

  const ApplyForEachDefeatedBaseAbility._({
    required this.ability,
  });
}

/// Destroy a card in play (or in the galaxy row).
final class DestroyCardAbility extends Ability {
  /// The selector to match cards with.
  final CardSelector selector;

  /// Whether the galaxy row can also be targeted.
  final bool orInGalaxyRow;

  const DestroyCardAbility._({
    required this.selector,
    required this.orInGalaxyRow,
  });
}

/// Look at your opponent's hand.
///
/// If the Force is with you, place 1 card from their hand on top of their
/// deck.
final class LookAtOpponentHandAbility extends Ability {
  const LookAtOpponentHandAbility._();
}

/// Deal the provided amount of damage to a card that matches a selector.
final class DealDamageAbility extends Ability {
  /// The amount of damage to deal.
  final int amount;

  /// The selector to match cards with.
  final CardSelector selector;

  const DealDamageAbility._({
    required this.amount,
    required this.selector,
  });
}

/// If you purchase this card, activate the specified ability.
///
/// Optionally, if the force is with you, activate another ability.
final class ActivateAbilityIfPurchasedAbility extends Ability {
  /// The ability to activate.
  final Ability ability;

  /// The ability to activate if the force is with you.
  final Ability? andIfForceIsWithYou;

  const ActivateAbilityIfPurchasedAbility._({
    required this.ability,
    this.andIfForceIsWithYou,
  });
}

/// Exile a card from the specified location.
///
/// Optionally provide an amount greater than 1 to exile multiple cards.
final class ExileCardAbility extends Ability {
  /// The location(s) to exile the card from.
  final Set<CardLocation> from;

  /// The amount of cards to exile.
  final int amount;

  ExileCardAbility._({
    required this.from,
    this.amount = 1,
  }) {
    _checkAmount(amount);
  }
}

/// Purchase a card from the galaxy row discard pile.
final class PurchaseCardFromGalaxyRowDiscardAbility extends Ability {
  const PurchaseCardFromGalaxyRowDiscardAbility._();
}

/// Place a purchased card on top of your deck.
final class PlacePurchasedCardOnTopOfDeckAbility extends Ability {
  const PlacePurchasedCardOnTopOfDeckAbility._();
}
