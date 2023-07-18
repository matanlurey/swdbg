import 'package:flutter/material.dart';

import '/src/models.dart' hide Card;
import '/src/utils.dart';

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
        height: 300,
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
          ],
        )
      ],
    );
  }
}
