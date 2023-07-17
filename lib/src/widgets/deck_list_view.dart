import 'package:flutter/material.dart';

import '/src/models/game.dart';

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

  /// Create a new deck list view.
  const DeckListView({
    required this.deck,
    required this.onCardRemoved,
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

    // Sort the card items by cost, then title.
    cardItems.sort((a, b) {
      if (a.card.cost != b.card.cost) {
        return b.card.cost.compareTo(a.card.cost);
      }
      return a.card.title.compareTo(b.card.title);
    });

    return SliverList.builder(
      itemCount: cardItems.length,
      itemBuilder: (context, index) {
        final item = cardItems[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(item.card.cost.toString()),
            radius: 20,
            backgroundColor: item.card.faction.color,
            foregroundColor: Colors.black,
          ),
          title: Text(item.card.title),
          subtitle: Text(
            '${item.count}x ${item.card.hitPoints != null ? 'Capital Ship' : 'Unit'}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              onCardRemoved(item.card);
            },
          ),
        );
      },
    );
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
