import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/src/models.dart';

/// A widget that displays a faction icon.
final class FactionIcon extends StatelessWidget {
  /// The faction to display.
  final Faction faction;

  /// A color filter to apply to the icon.
  final ColorFilter colorFilter;

  /// Create a new faction icon.
  FactionIcon({
    required this.faction,
    this.colorFilter = const ColorFilter.mode(
      Colors.white,
      BlendMode.srcIn,
    ),
  }) : super(key: ValueKey(faction));

  @override
  Widget build(BuildContext context) {
    switch (faction) {
      case Faction.rebel:
        return SvgPicture.asset(
          'assets/rebels.svg',
          colorFilter: colorFilter,
        );
      case Faction.imperial:
        return SvgPicture.asset(
          'assets/imperials.svg',
          colorFilter: colorFilter,
        );
      default:
        return SvgPicture.defaultPlaceholderBuilder(context);
    }
  }
}
