part of '../views.dart';

/// A view (widget) that displays the entire catalog of cards.
final class CatalogView extends StatelessWidget {
  /// The catalog to display.
  final List<GalaxyCard> catalog;

  /// Create a new catalog view.
  const CatalogView({
    required this.catalog,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
      ),
      body: ListView.separated(
        itemCount: catalog.length,
        itemBuilder: (context, index) {
          final card = catalog[index];
          return ListTile(
            onTap: () async {
              // https://github.com/flutter/flutter/issues/87766
              // Without this, the onTap closes the dialog!
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await showDialog<void>(
                  context: context,
                  builder: (_) => PreviewCardDialog(card),
                );
              });
            },
            leading: CircleAvatar(
              child: Text(card.cost.toString()),
              radius: 20,
              backgroundColor: card.faction.theme.primaryColor,
              foregroundColor: Colors.black,
            ),
            title: Text(card.title),
            subtitle: _CardSubTitle(card),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
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
