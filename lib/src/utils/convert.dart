part of '../utils.dart';

extension on Iterable<TextSpan> {
  /// Combines [TextSpan]s into a single [TextSpan] to mean "or".
  TextSpan orJoin() {
    return TextSpan(
      children: [
        for (final (i, s) in indexed)
          TextSpan(
            text: i == 0 ? null : ' or ',
            children: [s],
          )
      ],
    );
  }
}

/// Extensions that convert from [Ability] to [TextSpan].
extension AbilityToSpan on Ability {
  static final _chooseHeader = TextSpan(
    text: 'Choose: ',
    style: TextStyle(fontWeight: FontWeight.bold),
  );

  static TextSpan _choose(Iterable<Ability> abilities) {
    // Return Choose: <A> or <B>
    return TextSpan(
      children: [
        _chooseHeader,
        abilities.map((a) => a.toTextSpan()).orJoin(),
        TextSpan(text: '.'),
      ],
    );
  }

  static TextSpan _gain(int amount, String type) {
    return TextSpan(text: 'Gain $amount $type');
  }

  /// Creates a [TextSpan] from [Ability].
  TextSpan toTextSpan() {
    return switch (this) {
      GainAttackAbility(amount: final n) => _gain(n, 'attack'),
      GainResourcesAbility(amount: final n) => _gain(n, 'resources'),
      GainForceAbility(amount: final n) => _gain(n, 'force'),
      RepairBaseAbility(amount: final n) => TextSpan(text: 'Repair $n damage'),
      ChooseAbility(abilities: final a) => _choose(a),
      DrawCardAbility(
        amount: final n,
        ifConditionBonus: final i,
        ifMetApplyAbility: final a,
      ) =>
        TextSpan(
          text: 'Draw $n card${n == 1 ? '' : 's'}',
          children: [
            if (i != null && a == null)
              TextSpan(text: ' (${n + 1} if ', children: [
                i.toTextSpan(),
                TextSpan(text: ')'),
              ]),
            if (i != null && a != null)
              TextSpan(text: '(if ', children: [
                i.toTextSpan(),
                TextSpan(text: ', '),
                a.toTextSpan(),
                TextSpan(text: ')'),
              ]),
            TextSpan(text: '.'),
          ],
        ),
      AddCardAbility(
        from: final f,
        selector: final s,
      ) =>
        TextSpan(
          text: 'Add ',
          children: [
            if (s == null) TextSpan(text: 'a card') else s.toTextSpan(),
            if (f == CardLocation.currentCard) TextSpan(text: 'it'),
            if (f != CardLocation.currentPlayersDeck &&
                f != CardLocation.currentCard)
              TextSpan(text: ' from ', children: [f.toTextSpan()]),
            if (s != null) TextSpan(text: ' $s'),
          ],
        ),
      DiscardCardAbility(
        amount: final n,
        from: final f,
        ifForceIsWithYouAtRandom: final r,
      ) =>
        TextSpan(
          text: 'Discard $n card${n == 1 ? '' : 's'}',
          children: [
            if (f != CardLocation.currentPlayersHand)
              TextSpan(text: ' from ${f.name.camelToTitleCase()}'),
            if (r) TextSpan(text: ' (at random if the Force is with you)'),
            TextSpan(text: '.'),
          ],
        ),
      ApplyForEachAbility(
        selector: final s,
        ability: final a,
      ) =>
        TextSpan(
          text: 'Each ',
          children: [
            s.toTextSpan(),
            TextSpan(
              text: ' in play: ',
              children: [a.toTextSpan(), TextSpan(text: '.')],
            ),
          ],
        ),
      ApplyWhenAbility(
        condition: final c,
        ability: final a,
      ) =>
        TextSpan(
          text: 'When you ',
          children: [
            c.toTextSpan(),
            TextSpan(text: ': '),
            a.toTextSpan(),
            TextSpan(text: '.'),
          ],
        ),
      PurchaseCardAbility(
        selector: final s,
        to: final t,
      ) =>
        TextSpan(
          text: 'Purchase a ',
          children: [
            s.toTextSpan(),
            TextSpan(text: ' for free and add it to ', children: [
              t.toTextSpan(),
              TextSpan(text: '.'),
            ]),
          ],
        ),
      PurchaseCardFromGalaxyRowDiscardAbility() => const TextSpan(
          text: 'Purchase a card from the galaxy row discard pile.'),
      LookAtTopGalaxyCardAbility() => const TextSpan(
          text: 'Look at the top card of the galaxy deck. '
              'If the Force is with you, you may swap that card with a card '
              'from the galaxy row.',
        ),
      RevealTopGalaxyCardAbility(
        andIfMatches: final a,
        thenApply: final b,
      ) =>
        TextSpan(
          text: 'Reveal the top card of the galaxy deck. ',
          children: [
            TextSpan(text: 'If it is an ', children: [
              a.toTextSpan(),
              TextSpan(text: ' card,'),
            ]),
            TextSpan(children: [
              b.toTextSpan(),
              TextSpan(text: '. If it is an enemy card, discard it.'),
            ]),
          ],
        ),
      ApplyForEachDefeatedBaseAbility(
        ability: final a,
      ) =>
        TextSpan(
          text: 'For each defeated base: ',
          children: [
            a.toTextSpan(),
            TextSpan(text: '.'),
          ],
        ),
      DestroyCardAbility(
        selector: final s,
        orInGalaxyRow: final g,
      ) =>
        TextSpan(
          text: 'Destroy a ',
          children: [
            s.toTextSpan(),
            TextSpan(text: 'in play', children: [
              if (g) TextSpan(text: ' or in the galaxy row'),
            ]),
            TextSpan(text: '.'),
          ],
        ),
      LookAtOpponentHandAbility() => const TextSpan(
          text: "Look at your opponent's hand. "
              'If the Force is with you, place 1 card from their hand on '
              'top of their deck.'),
      DealDamageAbility(
        amount: final n,
        selector: final t,
      ) =>
        TextSpan(
          text: 'Deal $n damage to ',
          children: [
            t.toTextSpan(),
            TextSpan(text: '.'),
          ],
        ),
      ActivateAbilityIfPurchasedAbility(
        ability: final a,
        andIfForceIsWithYou: final f,
      ) =>
        TextSpan(
          text: 'When you purchase this card, ',
          children: [
            a.toTextSpan(),
            if (f != null)
              TextSpan(text: ' (and ', children: [
                f.toTextSpan(),
                TextSpan(text: ' if the Force is with you)')
              ]),
            TextSpan(text: '.'),
          ],
        ),
      ExileCardAbility(
        from: final f,
        amount: final n,
      ) =>
        TextSpan(
          text: 'Exile ',
          children: [
            if (n == 1)
              TextSpan(text: 'a card')
            else
              TextSpan(text: '$n cards'),
            TextSpan(
                text: ' from ',
                children: [f.map((l) => l.toTextSpan()).orJoin()]),
            TextSpan(text: '.'),
          ],
        ),
      PlacePurchasedCardOnTopOfDeckAbility() =>
        const TextSpan(text: 'Place a card you purchase on top of your deck.'),
    };
  }
}

/// Extensions that convert from [CardLocation] to [TextSpan].
extension CardLocationToSpan on CardLocation {
  /// Creates a [TextSpan] from [CardLocation].
  TextSpan toTextSpan() {
    return switch (this) {
      CardLocation.currentCard => const TextSpan(text: 'it'),
      CardLocation.currentPlayersDeck => const TextSpan(text: 'your deck'),
      CardLocation.currentPlayersHand => const TextSpan(text: 'your hand'),
      CardLocation.currentPlayersDiscardPile =>
        const TextSpan(text: 'your discard pile'),
      CardLocation.currentPlayersPlayArea =>
        const TextSpan(text: 'your play area'),
      CardLocation.opponentsHand =>
        const TextSpan(text: "your opponent's hand"),
      CardLocation.opponentsPlayArea =>
        const TextSpan(text: "your opponent's play area"),
      CardLocation.galaxyRow => const TextSpan(text: 'the galaxy row'),
      CardLocation.galaxyRowDiscardPile =>
        const TextSpan(text: 'the galaxy row discard pile'),
    };
  }
}

/// Extensions that convert from [PurchaseCardLocation] to [TextSpan].
extension PurchaseCardLocationToSpan on PurchaseCardLocation {
  /// Creates a [TextSpan] from [PurchaseCardLocation].
  TextSpan toTextSpan() {
    return switch (this) {
      PurchaseCardLocation.handAndExileAtEndOfTurn =>
        const TextSpan(text: 'your hand (and exile it at the end of the turn)'),
      PurchaseCardLocation.deckOnTopIfForceIsWithYou =>
        const TextSpan(text: 'your deck (on top if the Force is with you)'),
    };
  }
}

/// Extensions that convert from [Faction] to [TextSpan].
extension FactionToSpan on Faction {
  /// Creates a [TextSpan] from [Faction].
  TextSpan toTextSpan() {
    return switch (this) {
      Faction.imperial => const TextSpan(text: 'Imperial'),
      Faction.rebel => const TextSpan(text: 'Rebel'),
      Faction.neutral => const TextSpan(text: 'Neutral'),
    };
  }
}

/// Extensions that convert from [CardSelector] to [TextSpan].
extension CardSelectorToSpan on CardSelector {
  /// Creates a [TextSpan] from [CardSelector].
  TextSpan toTextSpan() {
    return switch (this) {
      CardTitleSelector(title: final t) => TextSpan(text: t),
      CardTraitSelector(traits: final t) => TextSpan(text: t.join(' or ')),
      CardUniqueSelector() => const TextSpan(text: 'unique card'),
      CardBaseSelector() => const TextSpan(text: 'base'),
      CardCapitalShipSelector() => const TextSpan(text: 'capital ship'),
      FactionSelector(faction: final f) => TextSpan(children: [
          f.toTextSpan(),
          TextSpan(text: ' card'),
        ]),
      CardSelectorOr(selectors: final s) => TextSpan(children: [
          s.map((s) => s.toTextSpan()).orJoin(),
        ]),
    };
  }
}

/// Extensions that convert from [Condition] to [TextSpan].
extension ConditionToSpan on Condition {
  /// Creates a [TextSpan] from [CardSelector].
  TextSpan toTextSpan() {
    return switch (this) {
      DefeatGalaxyRowCondition() =>
        const TextSpan(text: 'defeat a unit in the galaxy row'),
      AttackGalaxyRowCondition() =>
        const TextSpan(text: 'attack a unit in the galaxy row'),
      ForceIsWithYouCondition() =>
        const TextSpan(text: 'the Force is with you'),
      InPlayCondition(selector: final s) => TextSpan(text: 'a ', children: [
          s.toTextSpan(),
          TextSpan(text: ' in play'),
        ]),
      OpponentInPlayCondition(selector: final s) =>
        TextSpan(text: 'an enemy ', children: [
          s.toTextSpan(),
          TextSpan(text: ' is in play'),
        ]),
      IfYouCondition(ability: final a) => TextSpan(text: 'you ', children: [
          a.toTextSpan(),
        ]),
      IfOpponentDoesNotCondition(ability: final a) =>
        TextSpan(text: 'your opponent does not ', children: [
          a.toTextSpan(),
        ]),
      IfYouExileCurrentCardCondition() =>
        const TextSpan(text: 'you exile this card'),
    };
  }
}
