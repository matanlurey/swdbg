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
    _Imperial._deathTrooper,
    _Imperial._directorKrennic,
    _Imperial._generalVeers,
    _Imperial._gozantiCruiser,
    _Imperial._grandMoffTarkin,
    _Imperial._imperialCarrier,
    _Imperial._imperialShuttle,
    _Imperial._inqusitor,
    _Imperial._landingCraft,
    _Imperial._moffJerjerrod,
    _Imperial._scoutTrooper,
    _Imperial._starDestroyer,
    _Imperial._stormtrooper,
    _Imperial._tieBomber,
    _Imperial._tieFighter,
    _Imperial._tieInterceptor,
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
    _Rebel._snowspeeder,
    _Rebel._templeGuardian,
    _Rebel._uWing,
    _Rebel._xWing,
    _Rebel._yWing,
  ]);

  static final _allNeutral = List<GalaxyCard>.unmodifiable([
    _Neutral._blockadeRunner,
    _Neutral._bossk,
    _Neutral._cRocCruiser,
    _Neutral._dengar,
    _Neutral._fangFighter,
    _Neutral._hwk290,
    _Neutral._ig88,
    _Neutral._jabbasSailBarge,
    _Neutral._jabbatheHutt,
    _Neutral._jawaScavenger,
    _Neutral._kelDorMystic,
    _Neutral._landoCalrissian,
    _Neutral._lobot,
    _Neutral._nebulonBFrigate,
    _Neutral._outerRimPilot,
    _Neutral._rodianGunslinger,
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
    // Add a trooper from your discard pile to your hand.
    ability: Ability.addCard(
      from: CardLocation.currentPlayersDiscardPile,
      selector: CardSelector.byTraits({Trait.trooper}),
    ),
  );
  static final _atSt = UnitCard(
    faction: Faction.imperial,
    title: 'AT-ST',
    cost: 4,
    attack: 4,
    traits: {
      Trait.vehicle,
    },
    // Discard a card from the galaxy row.
    ability: Ability.discardCard(from: CardLocation.galaxyRow),
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
    // Each capital ship in play gains +1 attack.
    ability: Ability.applyForEach(
      selector: CardSelector.capitalShips(),
      ability: Ability.gainAttack(1),
    ),
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
    // When you defeat a card in the galaxy row, draw a card.
    ability: Ability.applyWhen(
      condition: Condition.defeatGalaxyRow(),
      ability: Ability.drawCard(),
    ),
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
    // If the force is with you, gain +4 attack.
    ability: Ability.applyWhen(
      condition: Condition.forceIsWithYou(),
      ability: Ability.gainAttack(4),
    ),
  );
  static final _deathTrooper = UnitCard(
    faction: Faction.imperial,
    title: 'Death Trooper',
    cost: 3,
    attack: 3,
    traits: {
      Trait.trooper,
    },
    // If the force is with you, gain +2 attack.
    ability: Ability.applyWhen(
      condition: Condition.forceIsWithYou(),
      ability: Ability.gainAttack(2),
    ),
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
    // Draw a card (2 if the Death Star is in play).
    ability: Ability.drawCard(
      ifConditionBonus: Condition.inPlay(CardSelector.byTitle('Death Star')),
    ),
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
    // Draw a card if a trooper or vehicle is in play.
    ability: Ability.applyWhen(
      condition: Condition.inPlay(
        CardSelector.byTraits(
          {
            Trait.trooper,
            Trait.vehicle,
          },
        ),
      ),
      ability: Ability.drawCard(),
    ),
  );
  static final _gozantiCruiser = CapitalShipCard(
    faction: Faction.imperial,
    title: 'Gozanti Cruiser',
    cost: 3,
    hitPoints: 3,
    resources: 2,
    // Discard a card from your hand to draw a card.
    ability: Ability.applyWhen(
      condition: Condition.ifYou(
        Ability.discardCard(from: CardLocation.currentPlayersHand),
      ),
      ability: Ability.drawCard(),
    ),
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
    // Purchase an Imperial card for free from the galaxy row, and add it to
    // your hand. Exile it at the end of the turn.
    ability: Ability.purchaseCardForFree(
      selector: CardSelector.faction(Faction.imperial),
      to: PurchaseCardLocation.handAndExileAtEndOfTurn,
    ),
  );
  static final _imperialCarrier = CapitalShipCard(
    faction: Faction.imperial,
    title: 'Imperial Carrier',
    cost: 5,
    hitPoints: 5,
    resources: 3,
    // Each fighter in play gains +1 attack.
    ability: Ability.applyForEach(
      selector: CardSelector.byTraits({Trait.fighter}),
      ability: Ability.gainAttack(1),
    ),
  );
  static final _imperialShuttle = UnitCard(
    faction: Faction.imperial,
    title: 'Imperial Shuttle',
    cost: 0,
    resources: 1,
  );
  static final _inqusitor = UnitCard(
    faction: Faction.imperial,
    title: 'Inquisitor',
    cost: 0,
    ability: Ability.gainAttack(1)
        .or(Ability.gainResources(1))
        .or(Ability.gainForce(1)),
  );
  static final _landingCraft = UnitCard(
    faction: Faction.imperial,
    title: 'Landing Craft',
    cost: 4,
    traits: {
      Trait.transport,
    },
    ability: Ability.gainResources(4).or(Ability.repairBase(4)),
  );
  static final _moffJerjerrod = UnitCard(
    faction: Faction.imperial,
    title: 'Moff Jerjerrod',
    isUnique: true,
    cost: 4,
    attack: 2,
    resources: 2,
    traits: {
      Trait.officer,
    },
    // Look at the top card of the galaxy deck.
    // If the Force is with you, you may swap that card with a card from the
    // galaxy row.
    ability: Ability.lookAtTopGalaxyCard(),
  );
  static final _scoutTrooper = UnitCard(
    faction: Faction.imperial,
    title: 'Scout Trooper',
    cost: 2,
    resources: 2,
    traits: {
      Trait.trooper,
    },
    // Reveal the top card from the galaxy deck.
    // If it is an Empire card, gain 1 force.
    // If it is an enemy card, discard it.
    ability: Ability.revealTopGalaxyCard(
      andIfMatches: CardSelector.faction(Faction.imperial),
      thenApply: Ability.gainForce(1),
    ),
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
    // Discard a card from the galaxy row.
    ability: Ability.discardCard(from: CardLocation.galaxyRow),
  );
  static final _tieFighter = UnitCard(
    faction: Faction.imperial,
    title: 'TIE Fighter',
    cost: 1,
    attack: 2,
    traits: {
      Trait.fighter,
    },
    // If you have a capital ship in play, draw a card.
    ability: Ability.applyWhen(
      condition: Condition.inPlay(CardSelector.capitalShips()),
      ability: Ability.drawCard(),
    ),
  );
  static final _tieInterceptor = UnitCard(
    faction: Faction.imperial,
    title: 'TIE Interceptor',
    cost: 3,
    attack: 3,
    traits: {
      Trait.fighter,
    },
    // Reveal the top card of the galaxy deck.
    // If it is an Empire card, draw 1 card.
    // If it is an enemy card, discard it.
    ability: Ability.revealTopGalaxyCard(
      andIfMatches: CardSelector.faction(Faction.imperial),
      thenApply: Ability.drawCard(),
    ),
  );
}

/// Namespace for all Rebel cards.
extension _Rebel on Never {
  static final _allianceShuttle = UnitCard(
    faction: Faction.rebel,
    title: 'Alliance Shuttle',
    cost: 0,
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
    // If your opponent does not discard a card, gain +2 attack.
    ability: Ability.applyWhen(
      condition: Condition.ifOpponentDoesNot(
        Ability.discardCard(
          from: CardLocation.opponentsHand,
        ),
      ),
      ability: Ability.gainAttack(2),
    ),
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
    // For each defeated base, gain +1 attack.
    ability: Ability.applyForEachDefeatedBase(ability: Ability.gainAttack(1)),
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
    // If you defeat a card in the galaxy row, opponent discards a card.
    ability: Ability.applyWhen(
      condition: Condition.defeatGalaxyRow(),
      ability: Ability.discardCard(from: CardLocation.opponentsHand),
    ),
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
    // If you have another unique card in play, draw a card.
    ability: Ability.applyWhen(
      condition: Condition.inPlay(CardSelector.unique()),
      ability: Ability.drawCard(),
    ),
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
    // If the force is with you, gain +2 attack.
    ability: Ability.applyWhen(
      condition: Condition.forceIsWithYou(),
      ability: Ability.gainAttack(2),
    ),
  );
  static final _durosSpy = UnitCard(
    faction: Faction.rebel,
    title: 'Duros Spy',
    cost: 2,
    resources: 2,
    traits: {
      Trait.scoundrel,
    },
    // If your opponent does not discard a card, gain 1 force.
    ability: Ability.applyWhen(
      condition: Condition.ifOpponentDoesNot(
        Ability.discardCard(
          from: CardLocation.opponentsHand,
        ),
      ),
      ability: Ability.gainForce(1),
    ),
  );
  static final _hammerheadCorvette = CapitalShipCard(
    faction: Faction.rebel,
    title: 'Hammerhead Corvette',
    cost: 4,
    hitPoints: 4,
    resources: 2,
    // If you exile this card, destroy a capital ship in play or galaxy row.
    ability: Ability.applyWhen(
      condition: Condition.ifYouExileCurrentCard(),
      ability: Ability.destroyCard(
        selector: CardSelector.capitalShips(),
        orInGalaxyRow: true,
      ),
    ),
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
    // Draw a card, 2 if Millennium Falcon is in play.
    ability: Ability.drawCard(
      ifConditionBonus: Condition.inPlay(
        CardSelector.byTitle('Millennium Falcon'),
      ),
    ),
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
    // Look at your opponent's hand.
    //
    // If the Force is with you, place 1 card from their hand on top of their
    // deck.
    ability: Ability.lookAtOpponentHand(),
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
    // If the Force is with you, destroy a capital ship in play.
    ability: Ability.applyWhen(
      condition: Condition.forceIsWithYou(),
      ability: Ability.destroyCard(
        selector: CardSelector.capitalShips(),
        orInGalaxyRow: false,
      ),
    ),
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
    // Add a unique card from your discard pile to your hand.
    ability: Ability.addCard(
      from: CardLocation.currentPlayersDiscardPile,
      selector: CardSelector.unique(),
    ),
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
    // Purchase a card from the galaxy row for free.
    // If the force is with you, place it on top of your deck instead.
    ability: Ability.purchaseCardForFree(
      selector: CardSelector.faction(Faction.rebel),
      to: PurchaseCardLocation.deckOnTopIfForceIsWithYou,
    ),
  );
  static final _rebelCommando = UnitCard(
    faction: Faction.rebel,
    title: 'Rebel Commando',
    cost: 3,
    attack: 3,
    traits: {
      Trait.trooper,
    },
    // Your opponent must discard a card.
    // If the force is with you, at random.
    ability: Ability.discardCard(
      from: CardLocation.opponentsHand,
      ifForceIsWithYouAtRandom: true,
    ),
  );
  static final _rebelTransport = CapitalShipCard(
    faction: Faction.rebel,
    title: 'Rebel Transport',
    cost: 2,
    hitPoints: 2,
    ability: Ability.gainResources(1).or(Ability.repairBase(2)),
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
  static final _snowspeeder = UnitCard(
    faction: Faction.rebel,
    title: 'Snowspeeder',
    cost: 2,
    attack: 2,
    traits: {
      Trait.vehicle,
    },
    ability: Ability.discardCard(from: CardLocation.opponentsHand),
  );
  static final _templeGuardian = UnitCard(
    faction: Faction.rebel,
    title: 'Temple Guardian',
    cost: 0,
    ability: Ability.gainAttack(1)
        .or(Ability.gainResources(1))
        .or(Ability.gainForce(1)),
  );
  static final _uWing = UnitCard(
    faction: Faction.rebel,
    title: 'U-Wing',
    cost: 4,
    resources: 3,
    traits: {
      Trait.transport,
    },
    // If the force is with you, repair 3.
    ability: Ability.applyWhen(
      condition: Condition.forceIsWithYou(),
      ability: Ability.repairBase(3),
    ),
  );
  static final _xWing = UnitCard(
    faction: Faction.rebel,
    title: 'X-Wing',
    cost: 3,
    attack: 3,
    traits: {
      Trait.fighter,
    },
    // If the force is with you, draw a card.
    ability: Ability.applyWhen(
      condition: Condition.forceIsWithYou(),
      ability: Ability.drawCard(),
    ),
  );
  static final _yWing = UnitCard(
    faction: Faction.rebel,
    title: 'Y-Wing',
    cost: 1,
    attack: 2,
    traits: {
      Trait.fighter,
    },
    // Exile to do 2 damage to a base or capital ship.
    ability: Ability.applyWhen(
      condition: Condition.ifYouExileCurrentCard(),
      ability: Ability.dealDamage(
        amount: 2,
        selector: CardSelector.capitalShips().or(CardSelector.bases()),
      ),
    ),
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
  static final _bossk = UnitCard(
    faction: Faction.neutral,
    title: 'Bossk',
    isUnique: true,
    cost: 3,
    attack: 3,
    traits: {
      Trait.bountyHunter,
    },
    // If you defeat a card in the galaxy row, gain 1 force.
    ability: Ability.applyWhen(
      condition: Condition.defeatGalaxyRow(),
      ability: Ability.gainForce(1),
    ),
  );
  static final _cRocCruiser = CapitalShipCard(
    faction: Faction.neutral,
    title: 'C-ROC Cruiser',
    cost: 3,
    hitPoints: 3,
    resources: 1,
    // If you discard a card, repair 3.
    ability: Ability.applyWhen(
      condition: Condition.ifYou(
        Ability.discardCard(
          from: CardLocation.currentPlayersHand,
        ),
      ),
      ability: Ability.repairBase(3),
    ),
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
    // If you defeat a card in the galaxy row, gain 2 resources.
    ability: Ability.applyWhen(
      condition: Condition.defeatGalaxyRow(),
      ability: Ability.gainResources(2),
    ),
  );
  static final _fangFighter = UnitCard(
    faction: Faction.neutral,
    title: 'Fang Fighter',
    cost: 3,
    attack: 3,
    traits: {
      Trait.fighter,
    },
    // Add to your hand, and if the force is with you, draw a card.
    ability: Ability.activateIfPurchased(
      ability: Ability.addCard(from: CardLocation.currentCard),
      andIfForceIsWithYou: Ability.drawCard(),
    ),
  );
  static final _hwk290 = UnitCard(
    faction: Faction.neutral,
    title: 'HWK-290',
    cost: 4,
    resources: 4,
    traits: {
      Trait.transport,
    },
    // Exile to repair 4.
    ability: Ability.applyWhen(
      condition: Condition.ifYouExileCurrentCard(),
      ability: Ability.repairBase(4),
    ),
  );
  static final _ig88 = UnitCard(
    faction: Faction.neutral,
    title: 'IG-88',
    isUnique: true,
    cost: 5,
    attack: 5,
    traits: {
      Trait.bountyHunter,
      Trait.droid,
    },
    // If you defeat a card in the galaxy row, exile a card from your hand or discard pile.
    ability: Ability.applyWhen(
      condition: Condition.defeatGalaxyRow(),
      ability: Ability.exileCard(
        from: {
          CardLocation.currentPlayersHand,
          CardLocation.currentPlayersDiscardPile,
        },
      ),
    ),
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
    // Exile a card from your hand to draw a card, 2 if the force is with you.
    ability: Ability.applyWhen(
      condition: Condition.ifYou(
        Ability.exileCard(from: {CardLocation.currentPlayersHand}),
      ),
      ability: Ability.drawCard(
        ifConditionBonus: Condition.forceIsWithYou(),
      ),
    ),
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
    ability: Ability.addCard(
      from: CardLocation.currentPlayersDiscardPile,
      selector: CardSelector.byTraits({Trait.bountyHunter}),
    ),
  );
  static final _jawaScavenger = UnitCard(
    faction: Faction.neutral,
    title: 'Jawa Scavenger',
    cost: 1,
    resources: 2,
    // Exile to purchase a card from the galaxy row discard pile.
    ability: Ability.applyWhen(
      condition: Condition.ifYouExileCurrentCard(),
      ability: Ability.purchaseCardFromGalaxyRowDiscardPile(),
    ),
  );
  static final _kelDorMystic = UnitCard(
    faction: Faction.neutral,
    title: 'Kel Dor Mystic',
    cost: 2,
    force: 2,
    // Exile to exile a card from your hand or discard pile.
    ability: Ability.applyWhen(
      condition: Condition.ifYouExileCurrentCard(),
      ability: Ability.exileCard(
        from: {
          CardLocation.currentPlayersHand,
          CardLocation.currentPlayersDiscardPile,
        },
      ),
    ),
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
    ability: Ability.drawCard(
      ifConditionBonus: Condition.forceIsWithYou(),
      ifMetApplyAbility: Ability.discardCard(from: CardLocation.opponentsHand),
    ),
  );
  static final _lobot = UnitCard(
    faction: Faction.neutral,
    title: 'Lobot',
    isUnique: true,
    cost: 3,
    traits: {
      Trait.officer,
    },
    ability: Ability.gainAttack(2)
        .or(Ability.gainResources(2))
        .or(Ability.gainForce(2)),
  );
  static final _nebulonBFrigate = CapitalShipCard(
    faction: Faction.neutral,
    title: 'Nebulon-B Frigate',
    cost: 5,
    hitPoints: 5,
    ability: Ability.gainResources(3).or(Ability.repairBase(3)),
  );
  static final _outerRimPilot = UnitCard(
    faction: Faction.neutral,
    title: 'Outer Rim Pilot',
    cost: 2,
    resources: 2,
    // Exile to gain 1 force.
    ability: Ability.applyWhen(
      condition: Condition.ifYouExileCurrentCard(),
      ability: Ability.gainForce(1),
    ),
  );
  static final _quarrenMercenary = UnitCard(
    faction: Faction.neutral,
    title: 'Quarren Mercenary',
    cost: 4,
    attack: 4,
    traits: {
      Trait.trooper,
    },
    // When purchased, exile 1 card from hand/discard, 2 if the force is with you.
    ability: Ability.activateIfPurchased(
      ability: Ability.exileCard(from: {
        CardLocation.currentPlayersHand,
        CardLocation.currentPlayersDiscardPile,
      }),
      andIfForceIsWithYou: Ability.exileCard(from: {
        CardLocation.currentPlayersHand,
        CardLocation.currentPlayersDiscardPile,
      }, amount: 2),
    ),
  );
  static final _rodianGunslinger = UnitCard(
    faction: Faction.neutral,
    title: 'Rodian Gunslinger',
    cost: 2,
    attack: 2,
    traits: {
      Trait.bountyHunter,
    },
    // If you attack a card on the galaxy row, gain +2 attack.
    ability: Ability.applyWhen(
      condition: Condition.attackGalaxyRow(),
      ability: Ability.gainAttack(2),
    ),
  );
  static final _twiLekSmuggler = UnitCard(
    faction: Faction.neutral,
    title: "Twi'lek Smuggler",
    cost: 3,
    resources: 3,
    traits: {
      Trait.scoundrel,
    },
    // Place a purchased card on top of your deck.
    ability: Ability.placePurchasedCardOnTopOfDeck(),
  );
  static final _z95Headhunter = UnitCard(
    faction: Faction.neutral,
    title: 'Z-95 Headhunter',
    cost: 2,
    attack: 2,
    traits: {
      Trait.fighter,
    },
    // If your opponent has a capital ship in play, draw a card.
    ability: Ability.applyWhen(
      condition: Condition.opponentInPlay(CardSelector.capitalShips()),
      ability: Ability.drawCard(),
    ),
  );
}
