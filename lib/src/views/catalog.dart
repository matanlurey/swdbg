part of '../views.dart';

/// A view (widget) that displays a catalog of cards.
final class CatalogView extends StatefulWidget {
  /// The catalog to display.
  final List<GalaxyCard> catalog;

  /// Callback when the user selects a card.
  ///
  /// If `false`, cards will not be selectable.
  final bool popOnCardSelected;

  /// Title of the view.
  final Widget title;

  /// Faction to start filtered by.
  final Faction? initiallyExcludeFaction;

  /// Whether to hide starter cards initially.
  final bool initiallyHideStarterCards;

  /// Create a new catalog view.
  const CatalogView._({
    required this.catalog,
    required this.title,
    this.popOnCardSelected = false,
    this.initiallyHideStarterCards = false,
    this.initiallyExcludeFaction,
    super.key,
  });

  /// Create a new catalog view without the ability to select a card.
  const CatalogView({
    required List<GalaxyCard> catalog,
    Key? key,
  }) : this._(
          catalog: catalog,
          title: const Text('Catalog'),
          key: key,
        );

  /// Create a new catalog view with the ability to select a card.
  factory CatalogView.selectCard({
    required List<GalaxyCard> catalog,
    Faction? initiallyExcludeFaction,
    bool initiallyHideStarterCards = false,
    Key? key,
  }) {
    return CatalogView._(
      catalog: catalog,
      title: const Text('Select Card'),
      popOnCardSelected: true,
      initiallyExcludeFaction: initiallyExcludeFaction,
      initiallyHideStarterCards: initiallyHideStarterCards,
      key: key,
    );
  }

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

/// A filter for the catalog.
final class _Filter {
  /// Label for the filter.
  final Widget label;

  /// Test to determine if a card should be included in the list.
  final bool Function(GalaxyCard) test;

  const _Filter({
    required this.label,
    required this.test,
  });
}

final class _CatalogViewState extends State<CatalogView> {
  late final _factionFilters = Faction.values.map((faction) {
    return _Filter(
      label: Text(faction.name.capitalize()),
      test: (card) => card.faction == faction,
    );
  }).toList();

  late final _starterCardFilter = _Filter(
    label: const Text('Starter Cards'),
    test: (card) => card.isStarter,
  );

  late final Set<_Filter> _excluded;
  int? _onlyIfCostEquals;
  late List<GalaxyCard> _cards = [];

  void _updateCards() {
    _cards = widget.catalog.where((card) {
      if (_onlyIfCostEquals != null && card.cost != _onlyIfCostEquals) {
        return false;
      }
      // If any filters test for true, exclude the card.
      return !_excluded.any((filter) => filter.test(card));
    }).toList();
    _cards.sort((a, b) {
      if (a.cost == b.cost) {
        return a.title.compareTo(b.title);
      }
      return a.cost.compareTo(b.cost);
    });
  }

  @override
  void initState() {
    super.initState();
    _excluded = {
      if (widget.initiallyExcludeFaction != null)
        _factionFilters.firstWhere(
          (filter) => filter.test(
            UnitCard(
              faction: widget.initiallyExcludeFaction!,
              title: 'Fake Card',
              cost: 0,
            ),
          ),
        ),
      if (widget.initiallyHideStarterCards) _starterCardFilter,
    };
    _updateCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        actions: [
          // Dropdown to modify filters to apply.
          PopupMenuButton<_Filter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) {
              setState(() {
                if (!_excluded.add(v)) {
                  _excluded.remove(v);
                }
                _updateCards();
              });
            },
            itemBuilder: (context) {
              return [
                // List factions.
                ..._factionFilters.map((filter) {
                  return CheckedPopupMenuItem(
                    checked: !_excluded.contains(filter),
                    value: filter,
                    child: filter.label,
                  );
                }),

                // Seperator
                const PopupMenuDivider(),

                // Starter cards.
                CheckedPopupMenuItem(
                  checked: !_excluded.contains(_starterCardFilter),
                  value: _starterCardFilter,
                  child: _starterCardFilter.label,
                ),
              ];
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 8,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (var i = 0; i <= 8; i++)
                    ButtonSegment(value: i, label: Text(i.toString())),
                ],
                emptySelectionAllowed: true,
                selected: {
                  if (_onlyIfCostEquals != null) _onlyIfCostEquals!,
                },
                onSelectionChanged: (v) {
                  setState(() {
                    if (v.isEmpty) {
                      _onlyIfCostEquals = null;
                    } else {
                      _onlyIfCostEquals = v.single;
                    }
                    _updateCards();
                  });
                },
              ),
            ),
          ),
          SliverList.separated(
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final card = _cards[index];
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
                trailing: !widget.popOnCardSelected
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          Navigator.of(context).pop(card);
                        },
                      ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          )
        ],
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
