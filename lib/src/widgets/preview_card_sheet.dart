part of '../widgets.dart';

/// Action to take when a card is previewed.
enum PreviewCardAction {
  /// Add the card to the deck.
  add,

  /// Remove the card from the deck.
  exile,

  /// Duplicate the card in the deck.
  duplicate,
}

/// Show a preview of the given card.
final class PreviewCardSheet extends StatelessWidget {
  /// Show a preview of the given card.
  ///
  /// Returns the action taken, if any.
  static Future<PreviewCardAction?> showAndCheckAdd(
    BuildContext context,
    GalaxyCard card, {
    Set<PreviewCardAction> actions = const {},
  }) {
    return showModalBottomSheet<PreviewCardAction>(
      context: context,
      builder: (_) => PreviewCardSheet._(
        card: card,
        actions: actions,
      ),
    );
  }

  /// Card being previewed.
  final GalaxyCard card;

  /// Whether to present an option to add the card to the deck.
  final Set<PreviewCardAction> actions;

  const PreviewCardSheet._({
    required this.card,
    this.actions = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _CardPreview(card),
          ButtonBar(
            children: [
              for (final action in actions)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(action),
                  child: Text(action.name.camelToTitleCase()),
                ),
            ],
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Ability'),
      subtitle: Text.rich(ability.toTextSpan()),
      isThreeLine: true,
    );
  }
}
