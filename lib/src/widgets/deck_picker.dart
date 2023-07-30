part of '../widgets.dart';

/// A menu that presents the user with a choice of loading a deck.
final class DeckPicker extends StatelessWidget {
  /// Create a new faction picker.
  const DeckPicker(this.onSelected);

  /// Called when the user selects a deck.
  final void Function(Deck) onSelected;

  void _selectRebels() {
    onSelected(
      Deck(
        faction: Faction.rebel,
        cards: CardDefinitions.instance.rebelStarterDeck(),
      ),
    );
  }

  void _selectEmpire() {
    onSelected(
      Deck(
        faction: Faction.imperial,
        cards: CardDefinitions.instance.imperialStarterDeck(),
      ),
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

  static final _catalogKey = GlobalKey();

  void _selectCatalog(BuildContext context) async {
    // Navigate to the catalog view.
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CatalogView(
          key: _catalogKey,
          catalog: [...CardDefinitions.instance.allGalaxy],
        ),
      ),
    );
  }

  void _selectAbout(BuildContext context) {
    // https://github.com/flutter/flutter/issues/87766
    // Without this, the onTap closes the dialog!
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<void>(
        context: context,
        builder: (_) => ChangelogDialog(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _Button(
        icon: FactionIcon(
          faction: Faction.rebel,
          colorFilter: ColorFilter.mode(
            Faction.rebel.theme.primaryColor,
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
            Faction.imperial.theme.primaryColor,
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
      _Button(
        icon: const Icon(Icons.list),
        label: 'Catalog',
        onPressed: () => _selectCatalog(context),
      ),
      _Button(
        icon: const Icon(Icons.info),
        label: 'About',
        onPressed: () => _selectAbout(context),
      )
    ];
    return ListView.separated(
      itemCount: buttons.length,
      itemBuilder: (_, index) => buttons[index],
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
