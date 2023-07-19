part of '../widgets.dart';

/// A widget that displays a player's deck.
///
/// This widget is used to display the player's deck in the main app. For each
/// card in the deck, it displays the card's name, its cost, faction, and a
/// button to remove the card from the deck.
///
/// Duplicate cards are collapsed into a single entry with a count of how many.
final class DeckListView extends StatelessWidget {
  /// The player's deck.
  final List<GalaxyCard> deck;

  /// Called when the user removes a card from the deck.
  final ValueChanged<GalaxyCard> onCardRemoved;

  /// Called when the user duplicates a card in the deck.
  final ValueChanged<GalaxyCard> onCardDuplicated;

  /// Sort the deck by this comparator.
  final Comparator<GalaxyCard> sortBy;

  /// Create a new deck list view.
  const DeckListView({
    required this.deck,
    required this.sortBy,
    required this.onCardRemoved,
    required this.onCardDuplicated,
  });

  @override
  Widget build(BuildContext context) {
    // Count the number of each card in the deck.
    final cardsAndCount = <GalaxyCard, int>{};
    for (final card in deck) {
      cardsAndCount[card] = (cardsAndCount[card] ?? 0) + 1;
    }

    // Create a list of card items, one for each card in the deck.
    final cardItems = <_CardItem>[];
    for (final card in cardsAndCount.entries) {
      cardItems.add(_CardItem(
        card: card.key,
        count: card.value,
      ));
    }

    // Sort the card items.
    cardItems.sort((a, b) => sortBy(a.card, b.card));

    return SliverList.builder(
      itemCount: cardItems.length,
      itemBuilder: (_, index) {
        final item = cardItems[index];
        return Dismissible(
          key: ValueKey(item.card.title),
          confirmDismiss: (_) async {
            onCardRemoved(item.card);
            return item.count == 1;
          },
          child: ListTile(
            onTap: () async {
              // https://github.com/flutter/flutter/issues/87766
              // Without this, the onTap closes the dialog!
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await showDialog<void>(
                  context: context,
                  builder: (_) => PreviewCardDialog(item.card),
                );
              });
            },
            leading: CircleAvatar(
              child: Text(item.card.cost.toString()),
              radius: 20,
              backgroundColor: item.card.faction.theme.primaryColor,
              foregroundColor: Colors.black,
            ),
            title: Text(item.card.title),
            subtitle: _CardSubTitle(item.card),
            trailing: Badge(
              label: Text(item.count.toString()),
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<void>(
                      child: const Text('Preview'),
                      onTap: () async {
                        // https://github.com/flutter/flutter/issues/87766
                        // Without this, the onTap closes the dialog!
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await showDialog<void>(
                            context: context,
                            builder: (_) => PreviewCardDialog(item.card),
                          );
                        });
                      },
                    ),
                    PopupMenuItem<void>(
                      child: const Text('Duplicate'),
                      onTap: () => onCardDuplicated(item.card),
                    ),
                    PopupMenuItem<void>(
                      child: const Text('Remove'),
                      onTap: () => onCardRemoved(item.card),
                    ),
                  ];
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

final class _CardSubTitle extends StatelessWidget {
  final GalaxyCard card;

  const _CardSubTitle(this.card);

  @override
  Widget build(BuildContext context) {
    final traits = card is UnitCard
        ? [
            'Unit',
            ...(card as UnitCard).traits.map((t) => t.name.camelToTitleCase())
          ]
        : ['Capital Ship'];
    return Text(traits.join(', '));
  }
}

final class _CardItem {
  final GalaxyCard card;
  final int count;

  const _CardItem({
    required this.card,
    required this.count,
  });
}
