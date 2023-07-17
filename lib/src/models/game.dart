import 'package:flutter/material.dart';

/// Factions present in the game.
enum Faction {
  /// Galactic Empire.
  imperial,

  /// Rebel Alliance.
  rebel,

  /// Neutral (smugglers, bounty hunters, etc.).
  neutral;

  /// The opposing faction, or `null` if this is [neutral].
  Faction? get opponent {
    switch (this) {
      case Faction.imperial:
        return Faction.rebel;
      case Faction.rebel:
        return Faction.imperial;
      default:
        return null;
    }
  }

  /// The theme color for this faction.
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

/// A card in the game.
@immutable
final class GalaxyCard {
  static const _allianceShuttle = GalaxyCard(
    faction: Faction.rebel,
    title: 'Alliance Shuttle',
    cost: 0,
    resources: 1,
  );

  static const _rebelTrooper = GalaxyCard(
    faction: Faction.rebel,
    title: 'Rebel Trooper',
    cost: 0,
    attack: 2,
  );

  static const _templeGuardian = GalaxyCard(
    faction: Faction.rebel,
    title: 'Temple Guardian',
    cost: 0,
    // TODO: Replace with an ability of 1 attack/resource/force.
    force: 1,
  );

  static const _imperialShuttle = GalaxyCard(
    faction: Faction.imperial,
    title: 'Imperial Shuttle',
    cost: 0,
    resources: 1,
  );

  static const _stormtrooper = GalaxyCard(
    faction: Faction.imperial,
    title: 'Stormtrooper',
    cost: 0,
    attack: 2,
  );

  static const _inquisitor = GalaxyCard(
    faction: Faction.imperial,
    title: 'Inquisitor',
    cost: 0,
    // TODO: Replace with an ability of 1 attack/resource/force.
    force: 1,
  );

  /// Cards that start in the Rebel player's deck.
  static final rebelStarter = List<GalaxyCard>.unmodifiable([
    // 7x Alliance Shuttle
    for (var i = 0; i < 7; i++) _allianceShuttle,

    // 2x Rebel Trooper
    for (var i = 0; i < 2; i++) _rebelTrooper,

    // 1x Temple Guardian
    _templeGuardian,
  ]);

  /// Cards that start in the Imperial player's deck.
  static final imperialStarter = List<GalaxyCard>.unmodifiable([
    // 7x Imperial Shuttle
    for (var i = 0; i < 7; i++) _imperialShuttle,

    // 2x Stormtrooper
    for (var i = 0; i < 2; i++) _stormtrooper,

    // 1x Inquisitor
    _inquisitor,
  ]);

  /// All cards in the game.
  static final allCards = List<GalaxyCard>.unmodifiable(const [
    // Neutral
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Blockade Runner',
      cost: 4,
      attack: 1,
      resources: 1,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'C-Roc Cruiser',
      cost: 3,
      hitPoints: 3,
      resources: 1,
      // TODO: Add repair 3 ability.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Nebulon-B Frigate',
      cost: 5,
      hitPoints: 5,
      // TODO: Replace with an ability of 3 resources or 3 repair.
      resources: 3,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Z-95 Headhunter',
      cost: 1,
      attack: 2,
      // TODO: Add draw card if opponent has a capital ship.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Jawa Scavenger',
      cost: 1,
      resources: 2,
      // TODO: Add exile to purchase from galaxy row discard pile.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Rodian Gunslinger',
      cost: 2,
      attack: 2,
      // TODO: Add 2 attack if attacking galaxy row.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Kel Dor Mystic',
      cost: 2,
      force: 2,
      // TODO: Add exile to exile another card from hand or discard pile.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Fang Fighter',
      cost: 3,
      attack: 3,
      // TODO: Add place into hand and draw a card if force with you.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: "Twi'lek Smuggler",
      cost: 3,
      resources: 3,
      // TODO: Add put first purchased card on top of deck.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Quarren Mercenary',
      cost: 4,
      attack: 4,
      // TODO: Add exile 1 (2 if force with you) when purchased.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'HWK-290',
      cost: 4,
      resources: 4,
      // TODO: Add exile for 4 repair.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Jabba the Hutt',
      cost: 8,
      attack: 2,
      resources: 2,
      force: 2,
      // TODO: Add exile card from hand to draw card (2 if force with you).
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: "Jabba's Sail Barge",
      cost: 7,
      attack: 4,
      resources: 3,
      // TODO: Add put bounty hunter from discard into hand when played.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Dengar',
      cost: 4,
      attack: 4,
      // TODO: Add gain 2 resources when defeating unit in galaxy row.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Lando Calrissian',
      cost: 6,
      attack: 3,
      resources: 3,
      // TODO: Add draw card, opponent discards card if force with you.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Lobot',
      cost: 3,
      // TODO: Change to 2 of any resource ability.
      force: 2,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Bossk',
      cost: 3,
      attack: 3,
      // TODO: Add if defeat unit in galaxy row, gain 1 force.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'IG-88',
      cost: 5,
      attack: 5,
      // TODO: Add if defeat unit in galaxy row, exile 1 card.
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Outer Rim Pilot',
      cost: 2,
      resources: 2,
      // TODO: Add if exile, gain 1 force.
    ),

    // Imperial
    _stormtrooper,
    _imperialShuttle,
    _inquisitor,
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Gozanti Cruiser',
      cost: 3,
      resources: 2,
      hitPoints: 3,
      // TODO: Add discard 1 card to draw 1 card.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Imperial Carrier',
      cost: 5,
      resources: 3,
      hitPoints: 5,
      // TODO: Add fighters gain +1 attack.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Star Destroyer',
      cost: 7,
      attack: 4,
      hitPoints: 7,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Tie Fighter',
      cost: 1,
      attack: 2,
      // TODO: Add draw card if capital ship in play.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Tie Bomber',
      cost: 2,
      attack: 2,
      // TODO: Add discard card in galaxy row.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Scout Trooper',
      cost: 2,
      resources: 2,
      // TODO: Add reveal top card of galaxy deck to discard or gain 1 force.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Death Trooper',
      cost: 3,
      attack: 3,
      // TODO: Add gain 2 attack if force with you.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Tie Interceptor',
      cost: 3,
      attack: 3,
      // TODO: Add reveal top card to draw a card or discard.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Landing Craft',
      cost: 4,
      // TODO: Replace with or repair 4.
      resources: 4,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'AT-ST',
      cost: 4,
      attack: 4,
      // TODO: Add discard card in galaxy row.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'AT-AT',
      cost: 6,
      attack: 6,
      // TODO: Add place a trooper from discard pile into hand.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Admiral Piett',
      cost: 2,
      resources: 2,
      // TODO: Add capital ships gain +1.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'General Veers',
      cost: 4,
      attack: 4,
      // TODO: Add draw a card if played a trooper or vehicle.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Moff Jerjerrod',
      cost: 4,
      attack: 2,
      resources: 2,
      // TODO: Add check top card, swap with galaxy row if force with you.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Grand Moff Tarkin',
      cost: 6,
      attack: 2,
      resources: 2,
      force: 2,
      // TODO: Add purchase empire card for free, exile at end of turn.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Director Krennic',
      cost: 5,
      attack: 3,
      resources: 2,
      // TODO: Add draw a card, 2 if death star in play.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Boba Fett',
      cost: 5,
      attack: 5,
      // TODO: Add draw a card if defeat unit in galaxy row.
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Darth Vader',
      cost: 8,
      attack: 6,
      force: 2,
      // TODO: Add gain +4 attack if force with you.
    ),

    // Rebel
    _rebelTrooper,
    _allianceShuttle,
    _templeGuardian,
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Rebel Transport',
      cost: 2,
      // TODO: Replace with ability of repair 2 or resources 1.
      resources: 1,
      hitPoints: 2,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Hammerhead Corvette',
      cost: 4,
      resources: 2,
      hitPoints: 4,
      // TODO: Add exile to discard from galaxy row or defeat capital ship.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Mon Calamari Cruiser',
      cost: 6,
      attack: 3,
      hitPoints: 6,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'X-Wing',
      cost: 3,
      attack: 3,
      // TODO: Add draw a card if force with you.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Y-Wing',
      cost: 1,
      attack: 2,
      // TODO: Add exile to deal 2 damage to capital ship or base.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Snowspeeder',
      cost: 2,
      attack: 2,
      // TODO: Add opponent discards a card.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Duros Spy',
      cost: 2,
      resources: 2,
      // TODO: Add opponent discards a card or you gain 1 force.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Rebel Commando',
      cost: 3,
      attack: 3,
      // TODO: Add opponent discards a card and if force with you it's random.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'U-Wing',
      cost: 4,
      resources: 3,
      // TODO: Add if force with you repair 3.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'B-Wing',
      cost: 5,
      attack: 5,
      // TODO: Add opponent discards a card or you gain 2 attack.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Han Solo',
      cost: 5,
      attack: 3,
      resources: 2,
      // TODO: Add draw a card (2 if Falcon in play).
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Millenium Falcon',
      cost: 7,
      attack: 5,
      resources: 2,
      // TODO: Add place unique card into hand from discard pile.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Chewbacca',
      cost: 4,
      attack: 5,
      // TODO: Add draw a card if another unique card in play.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Jyn Erso',
      cost: 4,
      attack: 4,
      // TODO: Add show oppoennt's hand, place 1 on top of deck if force w/.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Baze Malbus',
      cost: 2,
      attack: 2,
      // TODO: Add +1 attack for every defeated opponent base.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Chirrut Imwe',
      cost: 3,
      force: 2,
      // TODO: Add +2 attack if force with you.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Cassian Andor',
      cost: 5,
      attack: 5,
      // TODO: Add opponent discards a card if defeat unit in galaxy row.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Leia Organa',
      cost: 6,
      attack: 2,
      resources: 2,
      force: 2,
      // TODO: Add purchase rebel card for free and place on top of deck.
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Luke Skywalker',
      cost: 8,
      attack: 6,
      force: 2,
      // TODO: Add defeat capital ship if force w/ you.
    ),
  ]);

  /// Which faction this card belongs to.
  final Faction faction;

  /// Title of this card.
  final String title;

  /// Number of resources that must be spent to purchase this card.
  ///
  /// If this is `0`, then this card is a _starter_ card.
  final int cost;

  /// Amount of damage this card deals.
  final int attack;

  /// Number of resources this card generates.
  final int resources;

  /// Amount of force this card generates.
  final int force;

  /// Amount of damage required to destroy this card in a faction's play area.
  final int? hitPoints;

  /// Create a new card.
  const GalaxyCard({
    required this.faction,
    required this.title,
    required this.cost,
    this.attack = 0,
    this.resources = 0,
    this.force = 0,
    this.hitPoints,
  });

  /// Whether this card is a starter card.
  bool get isStarter => cost == 0;

  @override
  int get hashCode => Object.hash(faction, title);

  @override
  bool operator ==(Object other) {
    return other is GalaxyCard &&
        other.faction == faction &&
        other.title == title;
  }

  @override
  String toString() => 'GalaxyCard <$title>';
}

/// A base in the game.
@immutable
final class BaseCard {
  /// All bases in the game.
  static final allCards = List<BaseCard>.unmodifiable(const [
    // Imperial
    BaseCard(faction: Faction.imperial, title: 'Lothal'),
    BaseCard(faction: Faction.imperial, title: 'Corellia'),
    BaseCard(faction: Faction.imperial, title: 'Coruscant'),
    BaseCard(faction: Faction.imperial, title: 'Death Star'),
    BaseCard(faction: Faction.imperial, title: 'Endor'),
    BaseCard(faction: Faction.imperial, title: 'Mustafar'),
    BaseCard(faction: Faction.imperial, title: 'Kafrene'),
    BaseCard(faction: Faction.imperial, title: 'Ord Mantell'),
    BaseCard(faction: Faction.imperial, title: 'Kessel'),
    BaseCard(faction: Faction.imperial, title: 'Rodia'),

    // Rebel
    BaseCard(faction: Faction.rebel, title: 'Dantooine'),
    BaseCard(faction: Faction.rebel, title: 'Mon Cala'),
    BaseCard(faction: Faction.rebel, title: 'Tatooine'),
    BaseCard(faction: Faction.rebel, title: 'Sullust'),
    BaseCard(faction: Faction.rebel, title: 'Yavin 4'),
    BaseCard(faction: Faction.rebel, title: 'Hoth'),
    BaseCard(faction: Faction.rebel, title: 'Bespin'),
    BaseCard(faction: Faction.rebel, title: 'Dagoabah'),
    BaseCard(faction: Faction.rebel, title: 'Alderaan'),
    BaseCard(faction: Faction.rebel, title: 'Jedha'),
  ]);

  /// Which faction this base belongs to.
  final Faction faction;

  /// Title of this base.
  final String title;

  /// Create a new base.
  const BaseCard({
    required this.faction,
    required this.title,
  });

  @override
  int get hashCode => Object.hash(faction, title);

  @override
  bool operator ==(Object other) {
    return other is BaseCard &&
        other.faction == faction &&
        other.title == title;
  }

  @override
  String toString() => 'BaseCard <$title>';
}
