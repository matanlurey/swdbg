import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/src/models.dart';

/// A menu that presents the user with a choice of cards to add to their deck.
final class CardPicker extends StatelessWidget {
  /// The user's faction.
  ///
  /// If specified, cards from the opposing faction are not shown.
  final Faction? faction;

  /// Called when the user selects a card.
  final ValueChanged<GalaxyCard?> onCardSelected;

  /// Create a new card picker.
  const CardPicker({
    required this.onCardSelected,
    required this.faction,
  });

  @override
  Widget build(BuildContext context) {
    var cards = CardDefinitions.instance.allGalaxy;

    // If a faction is specified, filter out cards from the opposing faction.
    if (faction != null) {
      final opposing = faction!.opposing;
      cards = cards.where((card) => card.faction != opposing).toList();
    }

    // Next, filter out any starter cards.
    cards = cards.where((card) => !card.isStarter).toList();

    // Finally, sort the cards by name.
    // ignore: cascade_invocations
    cards.sort((a, b) => a.title.compareTo(b.title));

    // Return an auto-complete text field.
    return Autocomplete(
      optionsBuilder: (textEditingValue) {
        return cards.where((card) {
          final value = textEditingValue.text.trim().toLowerCase();
          final names = card.title.toLowerCase().split(' ');
          return names.any((name) => name.startsWith(value));
        });
      },
      displayStringForOption: (card) => card.title,
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Add a card',
          ),
          onSubmitted: (value) {
            final card = cards.firstWhereOrNull(
              (card) => card.title.toLowerCase() == value.toLowerCase(),
            );
            onCardSelected(card);
          },
        );
      },
      onSelected: onCardSelected,
    );
  }
}
