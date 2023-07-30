part of '../widgets.dart';

/// A list of cards in the catalog.
class CatalogSliverList extends StatelessWidget {
  /// The cards to display.
  final List<GalaxyCard> cards;

  /// Callback when the user taps a card.
  ///
  /// If `null`, cards will not be selectable.
  final void Function(GalaxyCard)? onCardSelected;

  /// Callback when a card was dismissed.
  ///
  /// If `null`, cards will not be dismissable.
  final void Function(GalaxyCard, int)? onCardDismissed;

  /// Create a new catalog sliver list.
  const CatalogSliverList({
    required this.cards,
    this.onCardSelected,
    this.onCardDismissed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cards = <(GalaxyCard, int)>[];

    // Determine if there are duplicate cards.
    for (final card in this.cards) {
      final index = cards.indexWhere((c) => c.$1.title == card.title);
      if (index == -1) {
        cards.add((card, 1));
      } else {
        cards[index] = (card, cards[index].$2 + 1);
      }
    }

    return SliverList.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final Widget content;
        if (card.$2 == 1) {
          content = Dismissible(
            key: ValueKey(card.$1.title),
            direction: onCardDismissed == null
                ? DismissDirection.none
                : DismissDirection.horizontal,
            background: const _DismissBackground.leftToRight(),
            secondaryBackground: const _DismissBackground.rightToLeft(),
            onDismissed: onCardDismissed == null
                ? null
                : (direction) {
                    onCardDismissed!(card.$1, 0);
                  },
            child: _GalaxyCard(
              card.$1,
              onCardSelected: onCardSelected == null
                  ? null
                  : () {
                      onCardSelected!(card.$1);
                    },
            ),
          );
        } else {
          content = _GalaxyCardSet(
            card.$1,
            card.$2,
            onCardSelected: onCardSelected == null
                ? null
                : () {
                    onCardSelected!(card.$1);
                  },
            onCardDismissed: onCardDismissed == null
                ? null
                : (card, index) {
                    onCardDismissed!(card, index);
                  },
          );
        }
        return content;
      },
    );
  }
}

final class _GalaxyCardSet extends StatelessWidget {
  /// The card to display.
  final GalaxyCard card;

  /// How many of the card to display.
  final int count;

  /// Callback when the user taps the card.
  final void Function()? onCardSelected;

  /// Callback when a card was dismissed.
  final void Function(GalaxyCard, int)? onCardDismissed;

  const _GalaxyCardSet(
    this.card,
    this.count, {
    this.onCardSelected,
    this.onCardDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (onCardSelected != null) {
          onCardSelected!();
        }
      },
      child: ExpansionTile(
        title: Text(card.title),
        subtitle: _CardSubTitle(card),
        leading: _AdaptiveAvatar(
          cost: card.cost,
          faction: card.faction,
          isCapitalShip: card is CapitalShipCard,
          isGrouping: true,
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Text('${count}x'),
        ),
        children: [
          for (var i = 0; i < count; i++)
            Dismissible(
              // This is sort of a hack, but it works.
              key: UniqueKey(),
              direction: onCardDismissed == null
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              background: const _DismissBackground.leftToRight(),
              secondaryBackground: const _DismissBackground.rightToLeft(),
              onDismissed: onCardDismissed == null
                  ? null
                  : (direction) {
                      onCardDismissed!(card, i);
                    },
              child: _GalaxyCard(
                card,
                onCardSelected: onCardSelected == null
                    ? null
                    : () {
                        onCardSelected!();
                      },
              ),
            ),
        ],
      ),
    );
  }
}

final class _DismissBackground extends StatelessWidget {
  final MainAxisAlignment _mainAxisAlignment;

  const _DismissBackground.leftToRight()
      : _mainAxisAlignment = MainAxisAlignment.start;

  const _DismissBackground.rightToLeft()
      : _mainAxisAlignment = MainAxisAlignment.end;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Row(
        mainAxisAlignment: _mainAxisAlignment,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

final class _GalaxyCard extends StatelessWidget {
  /// The card to display.
  final GalaxyCard card;

  /// Callback when the user taps the card.
  final void Function()? onCardSelected;

  const _GalaxyCard(
    this.card, {
    this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onCardSelected == null
          ? null
          : () {
              onCardSelected!();
            },
      leading: _AdaptiveAvatar(
        cost: card.cost,
        faction: card.faction,
        isCapitalShip: card is CapitalShipCard,
      ),
      title: Text.rich(TextSpan(text: card.title, children: [
        // If card is unique, show a unique symbol.
        if (card.isUnique) TextSpan(text: ' ✦'),
      ])),
      subtitle: _CardSubTitle(card),
      trailing: onCardSelected == null ? null : Icon(Icons.chevron_right),
    );
  }
}

final class _CardSubTitle extends StatelessWidget {
  final GalaxyCard card;

  const _CardSubTitle(this.card);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final traits = card is UnitCard
        ? [
            'Unit',
            ...(card as UnitCard).traits.map((t) => t.name.camelToTitleCase())
          ]
        : ['Capital Ship'];
    return Text(traits.join(', '), style: theme.textTheme.bodySmall);
  }
}

final class _AdaptiveAvatar extends StatelessWidget {
  /// The cost of the card.
  final int cost;

  /// Whether the card is a capital ship.
  final bool isCapitalShip;

  /// Faction the card belongs to.
  final Faction faction;

  /// Whether the avatar is being used to group cards.
  final bool isGrouping;

  const _AdaptiveAvatar({
    required this.cost,
    required this.isCapitalShip,
    required this.faction,
    this.isGrouping = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isGrouping
        ? faction.theme.primaryColorLight
        : faction.theme.primaryColor;
    if (isCapitalShip) {
      final theme = Theme.of(context);
      return _RectangleAvatar(
        child: Text(cost.toString(), style: theme.textTheme.bodyMedium),
        backgroundColor: color.withOpacity(0.85),
        foregroundColor: Colors.black,
      );
    } else {
      return CircleAvatar(
        child: Text(cost.toString()),
        radius: 20,
        backgroundColor: color.withOpacity(0.85),
        foregroundColor: Colors.black,
      );
    }
  }
}

final class _RectangleAvatar extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;

  const _RectangleAvatar({
    required this.child,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        child: child,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }
}
