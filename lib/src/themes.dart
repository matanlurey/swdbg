import 'package:flutter/material.dart';
import 'package:swdbg_log_app/src/models.dart';

/// A basic theme that uses the Rebel Alliance "red" color scheme.
final rebelTheme = ThemeData(
  primarySwatch: Colors.red,
);

/// A basic theme that uses the Galactic Empire "blue" color scheme.
final imperialTheme = ThemeData(
  primarySwatch: Colors.blue,
);

/// A basic theme that uses the neutral "gray" color scheme.
final neutralTheme = ThemeData(
  primarySwatch: Colors.grey,
);

/// Provides a theme for a faction.
extension FactionTheme on Faction {
  /// The theme for this faction.
  ThemeData get theme {
    switch (this) {
      case Faction.imperial:
        return imperialTheme;
      case Faction.rebel:
        return rebelTheme;
      case Faction.neutral:
        return neutralTheme;
    }
  }
}
