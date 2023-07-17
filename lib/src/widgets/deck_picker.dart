import 'dart:math' show Random;

import 'package:flutter/material.dart';

import '/src/actions.dart';
import '/src/models/deck.dart';
import '/src/models/game.dart';
import '/src/widgets/faction_icon.dart';

/// A menu that presents the user with a choice of loading a deck.
final class DeckPicker extends StatelessWidget {
  /// Create a new faction picker.
  DeckPicker(this.onSelected);

  /// Called when the user selects a deck.
  final void Function(Deck) onSelected;

  void _selectRebels() {
    onSelected(
      Deck(faction: Faction.rebel, cards: GalaxyCard.rebelStarter),
    );
  }

  void _selectEmpire() {
    onSelected(
      Deck(faction: Faction.imperial, cards: GalaxyCard.imperialStarter),
    );
  }

  void _selectRandom() {
    if (Random().nextBool()) {
      _selectRebels();
    } else {
      _selectEmpire();
    }
  }

  void _selectImport() async {
    final deck = await import();
    if (deck != null) {
      onSelected(deck);
    }
  }

  late final _buttons = [
    _Button(
      icon: FactionIcon(
        faction: Faction.rebel,
        colorFilter: ColorFilter.mode(
          Faction.rebel.color,
          BlendMode.srcIn,
        ),
      ),
      label: 'Rebel Alliance',
      onPressed: _selectRebels,
    ),
    _Button(
      icon: FactionIcon(
        faction: Faction.imperial,
        colorFilter: ColorFilter.mode(
          Faction.imperial.color,
          BlendMode.srcIn,
        ),
      ),
      label: 'Galactic Empire',
      onPressed: _selectEmpire,
    ),
    _Button(
      icon: const Icon(Icons.casino),
      label: 'Random',
      onPressed: _selectRandom,
    ),
    _Button(
      icon: const Icon(Icons.file_download),
      label: 'Import',
      onPressed: _selectImport,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _buttons.length,
      itemBuilder: (_, index) => _buttons[index],
      separatorBuilder: (_, __) => SizedBox(height: 8),
    );
  }
}

final class _Button extends StatelessWidget {
  const _Button({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 24,
        height: 24,
        child: icon,
      ),
      title: Text(label),
      onTap: onPressed,
    );
  }
}