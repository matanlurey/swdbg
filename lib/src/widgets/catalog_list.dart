part of '../widgets.dart';

/// A list of cards in the catalog.
class CatalogSliverList extends StatelessWidget {
  /// The cards to display.
  final List<GalaxyCard> cards;

  /// Callback when the user taps a card.
  ///
  /// If `null`, cards will not be selectable.
  final void Function(GalaxyCard)? onCardSelected;

  /// Create a new catalog sliver list.
  const CatalogSliverList({
    required this.cards,
    this.onCardSelected,
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
        if (card.$2 == 1) {
          return _GalaxyCard(
            card.$1,
            onCardSelected: onCardSelected == null
                ? null
                : () {
                    onCardSelected!(card.$1);
                  },
          );
        } else {
          return _GalaxyCardSet(
            card.$1,
            card.$2,
            onCardSelected: onCardSelected == null
                ? null
                : () {
                    onCardSelected!(card.$1);
                  },
          );
        }
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

  const _GalaxyCardSet(
    this.card,
    this.count, {
    this.onCardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(card.title),
      subtitle: _CardSubTitle(card),
      leading: CircleAvatar(
        child: Text(card.cost.toString()),
        radius: 20,
        backgroundColor: card.faction.theme.primaryColor,
        foregroundColor: Colors.black,
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 2),
        child: Text('${count}x'),
      ),
      children: [
        for (var i = 0; i < count; i++)
          _GalaxyCard(
            card,
            onCardSelected: onCardSelected == null
                ? null
                : () {
                    onCardSelected!();
                  },
          ),
      ],
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
      leading: CircleAvatar(
        child: Text(card.cost.toString()),
        radius: 20,
        backgroundColor: card.faction.theme.primaryColor,
        foregroundColor: Colors.black,
      ),
      title: Text(card.title),
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
