part of '../models.dart';

/// Contains aggregate information about a deck.
final class DeckSummary {
  /// Total amount of attack.
  final AttributeSummary attack;

  /// Total amount of hit points.
  final AttributeSummary hitPoints;

  /// Total amount of repair.
  final AttributeSummary repair;

  /// Total amount of resources.
  final AttributeSummary resources;

  /// Total amount of force.
  final AttributeSummary force;

  /// Create a new deck summary.
  const DeckSummary({
    required this.attack,
    required this.hitPoints,
    required this.repair,
    required this.resources,
    required this.force,
  });

  /// Create a new deck summary from a deck.
  factory DeckSummary.fromDeck(Iterable<GalaxyCard> deck) {
    var attack = AttributeSummary(baseTotal: 0);
    var hitPoints = AttributeSummary(baseTotal: 0);
    var repair = AttributeSummary(baseTotal: 0);
    var resources = AttributeSummary(baseTotal: 0);
    var force = AttributeSummary(baseTotal: 0);
    for (final card in deck) {
      attack += AttributeSummary(baseTotal: card.attack.toDouble());
      if (card is CapitalShipCard) {
        hitPoints += AttributeSummary(baseTotal: card.hitPoints.toDouble());
      }
      resources += AttributeSummary(baseTotal: card.resources.toDouble());
      force += AttributeSummary(baseTotal: card.force.toDouble());

      final ability = card.ability;
      if (ability is ChooseAbility) {
        for (final a in ability.abilities) {
          if (a is GainAttackAbility) {
            attack += AttributeSummary(
              baseTotal: 0,
              ifAbilitySelected: a.amount.toDouble(),
            );
          } else if (a is GainResourcesAbility) {
            resources += AttributeSummary(
              baseTotal: 0,
              ifAbilitySelected: a.amount.toDouble(),
            );
          } else if (a is GainForceAbility) {
            force += AttributeSummary(
              baseTotal: 0,
              ifAbilitySelected: a.amount.toDouble(),
            );
          } else if (a is RepairBaseAbility) {
            repair += AttributeSummary(
              baseTotal: 0,
              ifAbilitySelected: a.amount.toDouble(),
            );
          }
        }
      } else if (ability is ApplyWhenAbility) {
        final effect = ability.ability;
        if (effect is GainAttackAbility) {
          attack += AttributeSummary(
            baseTotal: 0,
            ifConditionIsMet: effect.amount.toDouble(),
          );
        } else if (effect is GainResourcesAbility) {
          resources += AttributeSummary(
            baseTotal: 0,
            ifConditionIsMet: effect.amount.toDouble(),
          );
        } else if (effect is GainForceAbility) {
          force += AttributeSummary(
            baseTotal: 0,
            ifConditionIsMet: effect.amount.toDouble(),
          );
        } else if (effect is RepairBaseAbility) {
          repair += AttributeSummary(
            baseTotal: 0,
            ifConditionIsMet: effect.amount.toDouble(),
          );
        }
      }
    }
    return DeckSummary(
      attack: attack,
      hitPoints: hitPoints,
      repair: repair,
      resources: resources,
      force: force,
    );
  }
}

/// Value of an attribute when summed together.
final class AttributeSummary {
  /// The base total of the attribute, assuming no player decisions or state.
  final double baseTotal;

  /// Additional attribute amount if a condition is met.
  final double ifConditionIsMet;

  /// Additional attribute amount if the current player opts into increasing.
  ///
  /// For example, if given the choices to "choose: gain 1 attack or gain 1
  /// resource", and this attribute represents "attack", the additional value
  /// would be present in this field.
  final double ifAbilitySelected;

  /// Create an attribute summary representing a possible tri-modal state.
  const AttributeSummary({
    required this.baseTotal,
    this.ifConditionIsMet = 0,
    this.ifAbilitySelected = 0,
  });

  /// Returns this summary added to another.
  AttributeSummary operator +(AttributeSummary other) {
    return AttributeSummary(
      baseTotal: baseTotal + other.baseTotal,
      ifConditionIsMet: ifConditionIsMet + other.ifConditionIsMet,
      ifAbilitySelected: ifAbilitySelected + other.ifAbilitySelected,
    );
  }

  /// The total amount possible for this attribute.
  double get maximum => baseTotal + ifConditionIsMet + ifAbilitySelected;
}
