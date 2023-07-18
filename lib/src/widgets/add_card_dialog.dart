import 'package:flutter/material.dart';

import '/src/models.dart';
import '/src/widgets/card_picker.dart';

/// A dialog that allows the user to add a card to their deck.
final class AddCardDialog extends StatefulWidget {
  /// The faction the user is playing as.
  final Faction? faction;

  /// Called when the user selects and adds a card.
  final ValueChanged<GalaxyCard> onCardAdded;

  /// Unique cards that cannot be added to the deck.
  final Set<GalaxyCard> uniqueCards;

  /// Create a new add card dialog widget.
  const AddCardDialog({
    required this.faction,
    required this.onCardAdded,
    required this.uniqueCards,
  });

  @override
  State<StatefulWidget> createState() => _AddCardDialogState();
}

final class _AddCardDialogState extends State<AddCardDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CardPicker(
        faction: widget.faction!,
        onCardSelected: (card) {
          widget.onCardAdded(card!);
          Navigator.of(context).pop();
        },
        uniqueCards: widget.uniqueCards,
      ),
    );
  }
}
