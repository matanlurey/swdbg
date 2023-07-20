part of '../widgets.dart';

/// A dialog that allows the user to preview a card.
final class PreviewCardDialog extends StatelessWidget {
  /// The card to preview.
  final GalaxyCard card;

  /// Create a new preview card dialog.
  const PreviewCardDialog(this.card);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        child: _CardPreview(card),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

final class _CardPreview extends StatelessWidget {
  final GalaxyCard card;

  const _CardPreview(this.card);

  @override
  Widget build(BuildContext context) {
    // Get theme for text styles.
    final text = Theme.of(context).textTheme;
    final card = this.card;
    return Column(
      children: [
        Text(
          '${card.isUnique ? '✦ ' : ''}${card.title}',
          style: text.titleLarge,
        ),
        Text(
          card is CapitalShipCard ? 'Capital Ship' : 'Unit',
          style: text.titleSmall,
        ),
        if (card is UnitCard)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...card.traits.map(
                  (t) => Chip(label: Text(t.name.camelToTitleCase())),
                ),
              ],
            ),
          ),
        ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Attack'),
              trailing: Text('${card.attack}'),
            ),
            ListTile(
              title: Text('Resources'),
              trailing: Text('${card.resources}'),
            ),
            ListTile(
              title: Text('Force'),
              trailing: Text('${card.force}'),
            ),
            if (card is CapitalShipCard)
              ListTile(
                title: Text('Hit Points'),
                trailing: Text('${card.hitPoints}'),
              ),
            if (card.ability != null) _AbilityPreview(card.ability!),
          ],
        )
      ],
    );
  }
}

final class _AbilityPreview extends StatelessWidget {
  final Ability ability;

  const _AbilityPreview(this.ability);

  static TextSpan _buildDescription(Ability ability) {
    return switch (ability) {
      GainAttackAbility(amount: final n) => TextSpan(text: 'Gain $n attack'),
      GainResourcesAbility(amount: final n) =>
        TextSpan(text: 'Gain $n resources'),
      GainForceAbility(amount: final n) => TextSpan(text: 'Gain $n force'),
      RepairBaseAbility(amount: final n) => TextSpan(text: 'Repair $n damage'),
      ChooseAbility(abilities: final a) => _buildChoose(a),
    };
  }

  static TextSpan _buildChoose(Iterable<Ability> abilities) {
    return TextSpan(
      children: [
        TextSpan(
          children: [
            TextSpan(
              text: 'Choose:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            for (final a in abilities)
              TextSpan(text: '\n• ', children: [_buildDescription(a)])
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('When Played'),
      subtitle: Text.rich(_buildDescription(ability)),
      isThreeLine: true,
    );
  }
}
