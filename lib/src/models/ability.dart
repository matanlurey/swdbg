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
