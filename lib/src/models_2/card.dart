part of '../models.dart';

/// Which faction a card belongs to.
enum Faction {
  /// Galactic Empire.
  imperial,

  /// Rebel Alliance.
  rebel,

  /// Neutral.
  neutral;

  /// The opposing faction, or `null` if the faction is neutral.
  Faction? get opposing {
    switch (this) {
      case Faction.imperial:
        return Faction.rebel;
      case Faction.rebel:
        return Faction.imperial;
      case Faction.neutral:
        return null;
    }
  }

  /// The theme color for the faction.
  ///
  /// TODO: Deprecate and replace with a proper Flutter-style/theme. Not here.
  Color get color {
    switch (this) {
      case Faction.imperial:
        return Colors.lightBlue;
      case Faction.rebel:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}

/// Traits that a card may have.
enum Trait {
  /// Bounty Hunter.
  bountyHunter,

  /// Droid.
  droid,

  /// Figther.
  fighter,

  /// Jedi.
  jedi,

  /// Officer.
  officer,

  /// Scoundrel.
  scoundrel,

  /// Transport.
  transport,

  /// Trooper.
  trooper,

  /// Vehicle.
  vehicle;
}

/// A base class for any card in the game "Star Wars: The Deck Building Game".
///
/// In practice, this class is never used directly. Instead, it is used as a
/// base class in order to share some common properties (and methods) between
/// all cards in the game.
@immutable
abstract base class Card {
  static final _validTitle = RegExp(r"^[a-zA-Z0-9]+([ -\']?[a-zA-Z0-9]+)*$");

  /// Title of the card.
  ///
  /// This is the title of the card as it appears on the card itself in US-En.
  /// When displaying the card to the user, internationalization may be used,
  /// but this title (as defined) is the unique key for the card.
  ///
  /// Restrictions:
  /// - Titles must be non-empty.
  /// - Titles must not contain trailing or leading spaces.
  /// - Titles may only contain alphanumeric characters or non-consective
  ///   spaces, hyphens, or apostrophes.
  /// - It is invalid for more than one card to have the same title.
  @nonVirtual
  final String title;

  /// Faction the card belongs to.
  @nonVirtual
  final Faction faction;

  /// Whether or not the card is unique.
  @nonVirtual
  final bool isUnique;

  /// Creates a new [Card] with the given [title] and [faction].
  ///
  /// If [isUnique] is not specified, it defaults to `false`.
  Card({
    required this.title,
    required this.faction,
    this.isUnique = false,
  }) {
    if (title.isEmpty) {
      throw ArgumentError.value(
        title,
        'title',
        'must be non-empty',
      );
    }
    if (title.startsWith(' ') || title.endsWith(' ')) {
      throw ArgumentError.value(
        title,
        'title',
        'must not have leading or trailing spaces',
      );
    }
    if (!_validTitle.hasMatch(title)) {
      throw ArgumentError.value(
        title,
        'title',
        'must only contain alphanumeric characters or non-consective spaces, hyphens, or apostrophes',
      );
    }
  }

  /// Whether or not the card is persistent (i.e. remains in play).
  bool get isPersistent;
}

/// A card that remains in play (and is not discarded) after being played.
base mixin PersistentCard on Card {
  /// Amount of damage the card can take before being defeated.
  ///
  /// Restrictions:
  /// - Must be greater than or equal to 1.
  int get hitPoints;

  @nonVirtual
  void _checkHitPoints() {
    if (hitPoints < 1) {
      throw ArgumentError.value(
        hitPoints,
        'hitPoints',
        'must be greater than or equal to 1',
      );
    }
  }

  @override
  @nonVirtual
  bool get isPersistent => true;
}

/// A base class for any card that can exist in a player's deck.
///
/// This class is used to share common properties (and methods) between all
/// cards that can exist in a player's deck, which includes all cards except
/// for [BaseCard]s.
sealed class GalaxyCard extends Card {
  /// Number of resources that must be spent to purchase this card.
  ///
  /// Restrictions:
  /// - Must be greater than or equal to 0.
  @nonVirtual
  final int cost;

  /// Amount of damage this card deals.
  ///
  /// Restrictions:
  /// - Must be greater than or equal to 0.
  @nonVirtual
  final int attack;

  /// Number of resoruces this card generates.
  ///
  /// Restrictions:
  /// - Must be greater than or equal to 0.
  @nonVirtual
  final int resources;

  /// Amount of Force this card generates.
  ///
  /// Restrictions:
  /// - Must be greater than or equal to 0.
  @nonVirtual
  final int force;

  /// Traits that this card has.
  @nonVirtual
  final Set<Trait> traits;

  /// Creates a new [GalaxyCard] with the given properties.
  ///
  /// See [Card] for more information.
  GalaxyCard({
    required super.title,
    required super.faction,
    required this.cost,
    super.isUnique,
    this.attack = 0,
    this.resources = 0,
    this.force = 0,
    this.traits = const {},
  }) {
    if (attack < 0) {
      throw ArgumentError.value(
        attack,
        'attack',
        'must be greater than or equal to 0',
      );
    }
    if (resources < 0) {
      throw ArgumentError.value(
        resources,
        'resources',
        'must be greater than or equal to 0',
      );
    }
    if (force < 0) {
      throw ArgumentError.value(
        force,
        'force',
        'must be greater than or equal to 0',
      );
    }
  }

  /// Whether or not the card is a starter card.
  @nonVirtual
  bool get isStarter => cost == 0;
}

/// A "Capital Ship" in the game "Star Wars: The Deck Building Game".
final class CapitalShipCard extends GalaxyCard with PersistentCard {
  @override
  final int hitPoints;

  /// Creates a new [CapitalShipCard] with the given properties.
  ///
  /// See [GalaxyCard] for more information.
  CapitalShipCard({
    required super.faction,
    required super.title,
    required super.cost,
    required this.hitPoints,
    super.isUnique,
    super.attack,
    super.resources,
    super.force,
  }) {
    _checkHitPoints();
  }
}

/// A "Unit" in the game "Star Wars: The Deck Building Game".
final class UnitCard extends GalaxyCard {
  /// Creates a new [UnitCard] with the given properties.
  ///
  /// See [GalaxyCard] for more information.
  UnitCard({
    required super.faction,
    required super.title,
    required super.cost,
    super.isUnique,
    super.attack,
    super.resources,
    super.force,
    super.traits,
  });

  @override
  bool get isPersistent => false;
}

/// A "Base" in the game "Star Wars: The Deck Building Game".
final class BaseCard extends Card with PersistentCard {
  @override
  final int hitPoints;

  /// Creates a new [BaseCard] with the given properties.
  ///
  /// See [Card] for more information.
  BaseCard({
    required super.faction,
    required super.title,
    required this.hitPoints,
    super.isUnique,
  }) {
    _checkHitPoints();
  }
}
