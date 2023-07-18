part of '../models.dart';

/// Provides an indexed list of all cards in the game.
///
/// This class is a singleton, and should be accessed via [instance].
final class CardDefinitions {
  static final _allGalaxy = List<GalaxyCard>.unmodifiable([
    ..._allImperial,
    ..._allRebel,
    ..._allNeutral,
  ]);

  static final _allImperial = List<GalaxyCard>.unmodifiable([
    _Imperial._atAt,
    _Imperial._atSt,
    _Imperial._admiralPiett,
    _Imperial._bobaFett,
    _Imperial._darthVader,
    _Imperial._directorKrennic,
    _Imperial._generalVeers,
    _Imperial._gozantiCruiser,
    _Imperial._grandMoffTarkin,
    _Imperial._imperialCarrier,
    _Imperial._imperialShuttle,
    _Imperial._inqusitor,
    _Imperial._landingCraft,
    _Imperial._scoutTrooper,
    _Imperial._starDestroyer,
    _Imperial._stormtrooper,
    _Imperial._tieBomber,
    _Imperial._tieFighter,
    _Imperial._tieInterceptor,
    Never.hashCode,
  ]);

  static final _allRebel = List<GalaxyCard>.unmodifiable([
    _Rebel._allianceShuttle,
    _Rebel._bWing,
    _Rebel._bazeMalbus,
    _Rebel._cassianAndor,
    _Rebel._chewbacca,
    _Rebel._chirrutImwe,
    _Rebel._durosSpy,
    _Rebel._hammerheadCorvette,
    _Rebel._hanSolo,
    _Rebel._jynErso,
    _Rebel._lukeSkywalker,
    _Rebel._millenniumFalcon,
    _Rebel._monCalamariCruiser,
    _Rebel._princessLeia,
    _Rebel._rebelCommando,
    _Rebel._rebelTransport,
    _Rebel._rebelTrooper,
    _Rebel._templeGuardian,
    _Rebel._uWing,
    _Rebel._xWing,
    _Rebel._yWing,
  ]);

  static final _allNeutral = List<GalaxyCard>.unmodifiable([
    _Neutral._blockadeRunner,
    _Neutral._cRocCruiser,
    _Neutral._dengar,
    _Neutral._fangFighter,
    _Neutral._hwk290,
    _Neutral._ig88,
    _Neutral._jabbasSailBarge,
    _Neutral._jabbatheHutt,
    _Neutral._kelDorMystic,
    _Neutral._landoCalrissian,
    _Neutral._lobot,
    _Neutral._nebulonBFrigate,
    _Neutral._outerRimPilot,
    _Neutral._quarrenMercenary,
    _Neutral._twiLekSmuggler,
    _Neutral._z95Headhunter,
  ]);

  /// Singleton instance of [CardDefinitions].
  ///
  /// This is the only instance of [CardDefinitions] that should be used, as the
  /// data is static and embedded in the source code. In a future version, this
  /// class will receive the data from a dynamic source.
  static final instance = CardDefinitions._();

  const CardDefinitions._();

  /// All galaxy cards.
  List<GalaxyCard> get allGalaxy => _allGalaxy;

  /// All Imperial cards.
  List<GalaxyCard> get allImperial => _allImperial;

  /// All Rebel cards.
  List<GalaxyCard> get allRebel => _allRebel;

  /// All Neutral cards.
  List<GalaxyCard> get allNeutral => _allNeutral;

  /// Creates an Imperial starter deck.
  List<GalaxyCard> imperialStarterDeck() {
    return List.unmodifiable([
      // 7x Imperial Shuttle.
      for (var i = 0; i < 7; i++) _Imperial._imperialShuttle,

      // 2x Stormtrooper.
      for (var i = 0; i < 2; i++) _Imperial._stormtrooper,

      // 1x Inquisitor.
      _Imperial._inqusitor,
    ]);
  }

  /// Creates a Rebel starter deck.
  List<GalaxyCard> rebelStarterDeck() {
    return List.unmodifiable([
      // 7x Alliance Shuttle.
      for (var i = 0; i < 7; i++) _Rebel._allianceShuttle,

      // 2x Rebel Trooper.
      for (var i = 0; i < 2; i++) _Rebel._rebelTrooper,

      // 1x Temple Guardian.
      _Rebel._templeGuardian,
    ]);
  }
}

/// Namespace for all Imperial cards.
extension _Imperial on Never {
  static final _atAt = UnitCard(
    faction: Faction.imperial,
    title: 'AT-AT',
    cost: 6,
    attack: 6,
    traits: {
      Trait.vehicle,
    },
  );
  static final _atSt = UnitCard(
    faction: Faction.imperial,
    title: 'AT-ST',
    cost: 4,
    attack: 4,
    traits: {
      Trait.vehicle,
    },
  );
  static final _admiralPiett = UnitCard(
    faction: Faction.imperial,
    title: 'Admiral Piett',
    isUnique: true,
    cost: 2,
    resources: 2,
    traits: {
      Trait.officer,
    },
  );
  static final _bobaFett = UnitCard(
    faction: Faction.imperial,
    title: 'Boba Fett',
    isUnique: true,
    cost: 5,
    attack: 5,
    traits: {
      Trait.bountyHunter,
    },
  );
  static final _darthVader = UnitCard(
    faction: Faction.imperial,
    title: 'Darth Vader',
    isUnique: true,
    cost: 8,
    attack: 6,
    force: 2,
    traits: {
      Trait.jedi,
    },
  );
  static final _directorKrennic = UnitCard(
    faction: Faction.imperial,
    title: 'Director Krennic',
    isUnique: true,
    cost: 5,
    attack: 3,
    resources: 2,
    traits: {
      Trait.officer,
    },
  );
  static final _generalVeers = UnitCard(
    faction: Faction.imperial,
    title: 'General Veers',
    isUnique: true,
    cost: 4,
    attack: 4,
    traits: {
      Trait.officer,
    },
  );
  static final _gozantiCruiser = CapitalShipCard(
    faction: Faction.imperial,
    title: 'Gozanti Cruiser',
    cost: 3,
    hitPoints: 3,
    resources: 2,
  );
  static final _grandMoffTarkin = UnitCard(
    faction: Faction.imperial,
    title: 'Grand Moff Tarkin',
    isUnique: true,
    cost: 6,
    attack: 2,
    resources: 2,
    force: 2,
    traits: {
      Trait.officer,
    },
  );
  static final _imperialCarrier = CapitalShipCard(
    faction: Faction.imperial,
    title: 'Imperial Carrier',
    cost: 5,
    hitPoints: 5,
    resources: 3,
  );
  static final _imperialShuttle = UnitCard(
    faction: Faction.imperial,
    title: 'Imperial Shuttle',
    cost: 1,
    resources: 1,
  );
  static final _inqusitor = UnitCard(
    faction: Faction.imperial,
    title: 'Inquisitor',
    cost: 0,
  );
  static final _landingCraft = UnitCard(
    faction: Faction.imperial,
    title: 'Landing Craft',
    cost: 4,
    traits: {
      Trait.transport,
    },
  );
  static final _scoutTrooper = UnitCard(
    faction: Faction.imperial,
    title: 'Scout Trooper',
    cost: 2,
    resources: 2,
    traits: {
      Trait.trooper,
    },
  );
  static final _starDestroyer = CapitalShipCard(
    faction: Faction.imperial,
    title: 'Star Destroyer',
    cost: 7,
    hitPoints: 7,
    attack: 4,
  );
  static final _stormtrooper = UnitCard(
    faction: Faction.imperial,
    title: 'Stormtrooper',
    cost: 0,
    attack: 2,
    traits: {
      Trait.trooper,
    },
  );
  static final _tieBomber = UnitCard(
    faction: Faction.imperial,
    title: 'TIE Bomber',
    cost: 2,
    attack: 2,
    traits: {
      Trait.fighter,
    },
  );
  static final _tieFighter = UnitCard(
    faction: Faction.imperial,
    title: 'TIE Fighter',
    cost: 1,
    attack: 2,
    traits: {
      Trait.fighter,
    },
  );
  static final _tieInterceptor = UnitCard(
    faction: Faction.imperial,
    title: 'TIE Interceptor',
    cost: 3,
    attack: 3,
    traits: {
      Trait.fighter,
    },
  );
}

/// Namespace for all Rebel cards.
extension _Rebel on Never {
  static final _allianceShuttle = UnitCard(
    faction: Faction.rebel,
    title: 'Alliance Shuttle',
    cost: 1,
    resources: 1,
  );
  static final _bWing = UnitCard(
    faction: Faction.rebel,
    title: 'B-Wing',
    cost: 5,
    attack: 5,
    traits: {
      Trait.fighter,
    },
  );
  static final _bazeMalbus = UnitCard(
    faction: Faction.rebel,
    title: 'Baze Malbus',
    isUnique: true,
    cost: 2,
    attack: 2,
    traits: {
      Trait.trooper,
    },
  );
  static final _cassianAndor = UnitCard(
    faction: Faction.rebel,
    title: 'Cassian Andor',
    isUnique: true,
    cost: 5,
    attack: 5,
    traits: {
      Trait.trooper,
    },
  );
  static final _chewbacca = UnitCard(
    faction: Faction.rebel,
    title: 'Chewbacca',
    isUnique: true,
    cost: 4,
    attack: 5,
    traits: {
      Trait.scoundrel,
    },
  );
  static final _chirrutImwe = UnitCard(
    faction: Faction.rebel,
    title: 'Chirrut Imwe',
    isUnique: true,
    cost: 3,
    force: 2,
    traits: {
      Trait.trooper,
    },
  );
  static final _durosSpy = UnitCard(
    faction: Faction.rebel,
    title: 'Duros Spy',
    cost: 2,
    resources: 2,
    traits: {
      Trait.scoundrel,
    },
  );
  static final _hammerheadCorvette = CapitalShipCard(
    faction: Faction.rebel,
    title: 'Hammerhead Corvette',
    cost: 4,
    hitPoints: 4,
    resources: 2,
  );
  static final _hanSolo = UnitCard(
    faction: Faction.rebel,
    title: 'Han Solo',
    isUnique: true,
    cost: 5,
    attack: 3,
    resources: 2,
    traits: {
      Trait.scoundrel,
    },
  );
  static final _jynErso = UnitCard(
    faction: Faction.rebel,
    title: 'Jyn Erso',
    isUnique: true,
    cost: 4,
    attack: 4,
    traits: {
      Trait.trooper,
    },
  );
  static final _lukeSkywalker = UnitCard(
    faction: Faction.rebel,
    title: 'Luke Skywalker',
    isUnique: true,
    cost: 6,
    attack: 6,
    force: 2,
    traits: {
      Trait.jedi,
    },
  );
  static final _millenniumFalcon = UnitCard(
    faction: Faction.rebel,
    title: 'Millennium Falcon',
    isUnique: true,
    cost: 7,
    attack: 5,
    resources: 2,
    traits: {
      Trait.transport,
    },
  );
  static final _monCalamariCruiser = CapitalShipCard(
    faction: Faction.rebel,
    title: 'Mon Calamari Cruiser',
    cost: 6,
    hitPoints: 6,
    attack: 3,
  );
  static final _princessLeia = UnitCard(
    faction: Faction.rebel,
    title: 'Princess Leia',
    isUnique: true,
    cost: 6,
    attack: 2,
    resources: 2,
    force: 2,
    traits: {
      Trait.officer,
    },
  );
  static final _rebelCommando = UnitCard(
    faction: Faction.rebel,
    title: 'Rebel Commando',
    cost: 3,
    attack: 3,
    traits: {
      Trait.trooper,
    },
  );
  static final _rebelTransport = CapitalShipCard(
    faction: Faction.rebel,
    title: 'Rebel Transport',
    cost: 2,
    hitPoints: 2,
  );
  static final _rebelTrooper = UnitCard(
    faction: Faction.rebel,
    title: 'Rebel Trooper',
    cost: 0,
    attack: 2,
    traits: {
      Trait.trooper,
    },
  );
  static final _templeGuardian = UnitCard(
    faction: Faction.rebel,
    title: 'Temple Guardian',
    cost: 0,
  );
  static final _uWing = UnitCard(
    faction: Faction.rebel,
    title: 'U-Wing',
    cost: 4,
    resources: 3,
    traits: {
      Trait.transport,
    },
  );
  static final _xWing = UnitCard(
    faction: Faction.rebel,
    title: 'X-Wing',
    cost: 3,
    attack: 3,
    traits: {
      Trait.fighter,
    },
  );
  static final _yWing = UnitCard(
    faction: Faction.rebel,
    title: 'Y-Wing',
    cost: 1,
    attack: 2,
    traits: {
      Trait.fighter,
    },
  );
}

/// Namespace for all Neutral cards.
extension _Neutral on Never {
  static final _blockadeRunner = CapitalShipCard(
    faction: Faction.neutral,
    title: 'Blockade Runner',
    cost: 4,
    hitPoints: 4,
    attack: 1,
    resources: 1,
  );
  static final _cRocCruiser = CapitalShipCard(
    faction: Faction.neutral,
    title: 'C-ROC Cruiser',
    cost: 3,
    hitPoints: 3,
    resources: 1,
  );
  static final _dengar = UnitCard(
    faction: Faction.neutral,
    title: 'Dengar',
    isUnique: true,
    cost: 4,
    attack: 4,
    traits: {
      Trait.bountyHunter,
    },
  );
  static final _fangFighter = UnitCard(
    faction: Faction.neutral,
    title: 'Fang Fighter',
    cost: 3,
    attack: 3,
    traits: {
      Trait.fighter,
    },
  );
  static final _hwk290 = UnitCard(
    faction: Faction.neutral,
    title: 'HWK-290',
    cost: 4,
    resources: 4,
    traits: {
      Trait.transport,
    },
  );
  static final _ig88 = UnitCard(
    faction: Faction.neutral,
    title: 'IG-88',
    isUnique: true,
    cost: 5,
    attack: 5,
    traits: {
      Trait.bountyHunter,
    },
  );
  static final _jabbatheHutt = UnitCard(
    faction: Faction.neutral,
    title: 'Jabba the Hutt',
    isUnique: true,
    cost: 8,
    attack: 2,
    resources: 2,
    force: 2,
    traits: {
      Trait.scoundrel,
    },
  );
  static final _jabbasSailBarge = UnitCard(
    faction: Faction.neutral,
    title: "Jabba's Sail Barge",
    isUnique: true,
    cost: 6,
    attack: 4,
    resources: 3,
    traits: {
      Trait.vehicle,
    },
  );
  static final _kelDorMystic = UnitCard(
    faction: Faction.neutral,
    title: 'Kel Dor Mystic',
    cost: 2,
    force: 2,
  );
  static final _landoCalrissian = UnitCard(
    faction: Faction.neutral,
    title: 'Lando Calrissian',
    isUnique: true,
    cost: 6,
    attack: 3,
    resources: 3,
    traits: {
      Trait.scoundrel,
    },
  );
  static final _lobot = UnitCard(
    faction: Faction.neutral,
    title: 'Lobot',
    isUnique: true,
    cost: 3,
    traits: {
      Trait.officer,
    },
  );
  static final _nebulonBFrigate = CapitalShipCard(
    faction: Faction.neutral,
    title: 'Nebulon-B Frigate',
    cost: 5,
    hitPoints: 5,
  );
  static final _outerRimPilot = UnitCard(
    faction: Faction.neutral,
    title: 'Outer Rim Pilot',
    cost: 2,
    resources: 2,
  );
  static final _quarrenMercenary = UnitCard(
    faction: Faction.neutral,
    title: 'Quarren Mercenary',
    cost: 4,
    attack: 4,
    traits: {
      Trait.trooper,
    },
  );
  static final _twiLekSmuggler = UnitCard(
    faction: Faction.neutral,
    title: "Twi'lek Smuggler",
    cost: 3,
    resources: 3,
    traits: {
      Trait.scoundrel,
    },
  );
  static final _z95Headhunter = UnitCard(
    faction: Faction.neutral,
    title: 'Z-95 Headhunter',
    cost: 2,
    attack: 2,
    traits: {
      Trait.fighter,
    },
  );
}
