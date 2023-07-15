import 'package:flutter/material.dart';

import '/src/models/game.dart';
import '/src/widgets/faction_icon.dart';

/// A menu that presents the user with a choice of factions.
final class FactionPicker extends StatelessWidget {
  /// Create a new faction picker.
  const FactionPicker({
    required this.onFactionSelected,
  });

  /// Called when the user selects a faction.
  final ValueChanged<Faction> onFactionSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  onFactionSelected(Faction.rebel);
                },
                icon: SizedBox(
                  height: 16,
                  width: 16,
                  child: FactionIcon(faction: Faction.rebel),
                ),
                label: const Text('Rebel Alliance'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  onFactionSelected(Faction.imperial);
                },
                icon: SizedBox(
                  height: 16,
                  width: 16,
                  child: FactionIcon(faction: Faction.imperial),
                ),
                label: const Text('Galactic Empire'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
