part of '../utils.dart';

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
        for (final (i, a) in abilities.indexed)
          TextSpan(
            text: i == 0 ? null : ' or ',
            children: [
              a.toTextSpan(),
              if (i == abilities.length - 1) TextSpan(text: '.'),
            ],
          )
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
      ) =>
        TextSpan(
          text: 'Draw $n card${n == 1 ? '' : 's'}',
        ),
      AddCardAbility(
        from: final f,
        selector: final s,
      ) =>
        TextSpan(
          text: 'Add a ',
          children: [
            if (s == null) TextSpan(text: 'card') else s.toTextSpan(),
            if (f != CardLocation.currentPlayersDeck)
              TextSpan(text: ' from $f'),
            if (s != null) TextSpan(text: ' $s'),
          ],
        ),
      DiscardCardAbility(
        amount: final n,
        from: final f,
      ) =>
        TextSpan(
          text: 'Discard $n card${n == 1 ? '' : 's'}',
          children: [
            if (f != CardLocation.currentPlayersHand)
              TextSpan(text: ' from ${f.name.camelToTitleCase()}'),
          ],
        ),
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
    };
  }
}
