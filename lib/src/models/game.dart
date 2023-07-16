import 'package:meta/meta.dart';

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
}

/// A card in the game.
@immutable
final class GalaxyCard {
  static const _allianceShuttle = GalaxyCard(
    faction: Faction.rebel,
    title: 'Alliance Shuttle',
    cost: 0,
  );

  static const _rebelTrooper = GalaxyCard(
    faction: Faction.rebel,
    title: 'Rebel Trooper',
    cost: 0,
  );

  static const _templeGuardian = GalaxyCard(
    faction: Faction.rebel,
    title: 'Temple Guardian',
    cost: 0,
  );

  static const _imperialShuttle = GalaxyCard(
    faction: Faction.imperial,
    title: 'Imperial Shuttle',
    cost: 0,
  );

  static const _stormtrooper = GalaxyCard(
    faction: Faction.imperial,
    title: 'Stormtrooper',
    cost: 0,
  );

  static const _inquisitor = GalaxyCard(
    faction: Faction.imperial,
    title: 'Inquisitor',
    cost: 0,
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
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'C-Roc Cruiser',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Nebulon-B Frigate',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Z-95 Headhunter',
      cost: 1,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Jawa Scavenger',
      cost: 1,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Rodian Gunslinger',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Kel Dor Mystic',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Fang Fighter',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: "Twi'lek Smuggler",
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Quarren Mercenary',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'HWK-290',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Jabba the Hutt',
      cost: 8,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: "Jabba's Sail Barge",
      cost: 7,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Dengar',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Lando Calrissian',
      cost: 6,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Lobot',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Bossk',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'IG-88',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.neutral,
      title: 'Outer Rim Pilot',
      cost: 2,
    ),

    // Imperial
    _stormtrooper,
    _imperialShuttle,
    _inquisitor,
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Gozanti Cruiser',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Imperial Carrier',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Star Destroyer',
      cost: 7,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Tie Fighter',
      cost: 1,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Tie Bomber',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Scout Trooper',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Death Trooper',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Tie Interceptor',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Landing Craft',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'AT-ST',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'AT-AT',
      cost: 6,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Admiral Piett',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'General Veers',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Moff Jerjerrod',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Grand Moff Tarkin',
      cost: 6,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Director Krennic',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Boba Fett',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.imperial,
      title: 'Darth Vader',
      cost: 8,
    ),

    // Rebel
    _rebelTrooper,
    _allianceShuttle,
    _templeGuardian,
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Rebel Transport',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Hammerhead Corvette',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Mon Calamari Cruiser',
      cost: 6,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'X-Wing',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Y-Wing',
      cost: 1,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Snowspeeder',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Duros Spy',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Rebel Commando',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'U-Wing',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'B-Wing',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Han Solo',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Millenium Falcon',
      cost: 7,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Chewbacca',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Jyn Erso',
      cost: 4,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Baze Malbus',
      cost: 2,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Chirrut Imwe',
      cost: 3,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Cassian Andor',
      cost: 5,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Leia Organa',
      cost: 6,
    ),
    GalaxyCard(
      faction: Faction.rebel,
      title: 'Luke Skywalker',
      cost: 8,
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
