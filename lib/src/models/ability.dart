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
  factory Ability.drawCard({
    int amount,
  }) = DrawCardAbility._;

  /// Add a card from a location to the player's hand.
  const factory Ability.addCard({
    required CardLocation from,
    CardSelector? selector,
  }) = AddCardAbility._;

  /// Discard a card, or card(s), from a location.
  ///
  /// Amount must be a positive number; defaults to 1.
  factory Ability.discardCard({
    required CardLocation from,
    int amount,
  }) = DiscardCardAbility._;
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

  DrawCardAbility._({
    this.amount = 1,
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

  DiscardCardAbility._({
    required this.from,
    this.amount = 1,
  }) {
    _checkAmount(amount);
  }
}
