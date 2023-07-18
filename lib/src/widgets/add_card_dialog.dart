import 'package:flutter/material.dart';

import '/src/models.dart';
import '/src/widgets/card_picker.dart';

/// A dialog that allows the user to add a card to their deck.
final class AddCardDialog extends StatefulWidget {
  /// The faction the user is playing as.
  final Faction? faction;

  /// Called when the user selects and adds a card.
  final ValueChanged<GalaxyCard> onCardAdded;

  /// Create a new add card dialog widget.
  const AddCardDialog({
    required this.faction,
    required this.onCardAdded,
  });

  @override
  State<StatefulWidget> createState() => _AddCardDialogState();
}

final class _AddCardDialogState extends State<AddCardDialog> {
  GalaxyCard? _selectedCard;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CardPicker(
        faction: widget.faction!,
        onCardSelected: (card) {
          setState(() {
            _selectedCard = card;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _selectedCard == null
              ? null
              : () {
                  widget.onCardAdded(_selectedCard!);
                  Navigator.of(context).pop();
                },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
