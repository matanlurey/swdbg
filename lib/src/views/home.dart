part of '../views.dart';

/// Home view that allows starting a new game and a few other options.
final class HomeView extends StatelessWidget {
  /// Shared preferences.
  final SharedPreferences preferences;

  /// Create a new home view.
  const HomeView({
    required this.preferences,
    super.key,
  });

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
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DeckView(
                initialDeck: Deck(
                  faction: Faction.rebel,
                  cards: CardDefinitions.instance.rebelStarterDeck(),
                ),
              ),
            ),
          );
        },
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
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DeckView(
                initialDeck: Deck(
                  faction: Faction.imperial,
                  cards: CardDefinitions.instance.imperialStarterDeck(),
                ),
              ),
            ),
          );
        },
      ),
      _Button(
        icon: const Icon(Icons.casino),
        label: 'Random',
        onPressed: () async {
          // Show a bottom sheet with the random options.
          final result = await showModalBottomSheet<Deck>(
            context: context,
            builder: (_) => _ConfigureRandomSheet(),
          );
          if (result != null) {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => DeckView(
                  initialDeck: result,
                ),
              ),
            );
          }
        },
      ),
      _Button(
        icon: const Icon(Icons.file_download),
        label: 'Import',
        onPressed: () async {
          // Show a bottom sheet with the import options.
          final result = await showModalBottomSheet<Deck>(
            context: context,
            builder: (_) => _ImportDeckSheet(),
          );
          if (result != null) {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => DeckView(
                  initialDeck: result,
                ),
              ),
            );
          }
        },
      ),
      _Button(
        icon: const Icon(Icons.list),
        label: 'Catalog',
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CatalogView(
                catalog: [
                  ...CardDefinitions.instance.allGalaxy,
                ],
              ),
            ),
          );
        },
      ),
      _Button(
        icon: const Icon(Icons.settings),
        label: 'Settings',
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SettingsView(
                preferences: preferences,
              ),
            ),
          );
        },
      ),
      _Button(
        icon: const Icon(Icons.info),
        label: 'About',
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ChangelogView(),
            ),
          );
        },
      )
    ];
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 32),
            Text(
              'Star Wars: Deck Building Game',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            Text(
              'Unofficial Companion App',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 300,
              height: 500,
              child: ListView.separated(
                itemCount: buttons.length,
                itemBuilder: (_, index) => buttons[index],
                separatorBuilder: (_, __) => const SizedBox(height: 8),
              ),
            ),
          ],
        ),
      ),
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
      trailing: Icon(Icons.chevron_right),
      onTap: onPressed,
    );
  }
}

final class _ImportDeckSheet extends StatelessWidget {
  const _ImportDeckSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Header
          Text(
            'Import Deck',
            style: theme.textTheme.titleSmall,
          ),

          Text(
            'Recent Autosaves',
          ),

          // Recent
          Expanded(
            child: FutureBuilder(
              // ignore: discarded_futures
              future: fetchAutoSaves(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final decks = snapshot.data!;

                return ListView.separated(
                  itemBuilder: (_, i) {
                    final deck = decks[i].$1;
                    final time = decks[i].$2;
                    // ignore: avoid_types_on_closure_parameters
                    final preview = (List<GalaxyCard> cards) {
                      cards.sort((a, b) => b.cost.compareTo(a.cost));
                      final titles = cards.map((c) => c.title).toSet();
                      return titles.take(2).join(', ');
                    }(deck.cards.toList());
                    return Dismissible(
                      key: ValueKey(deck.uri),
                      background: _DismissBackground.leftToRight(),
                      secondaryBackground: _DismissBackground.rightToLeft(),
                      onDismissed: (_) async {
                        await File.fromUri(deck.uri!).delete();
                      },
                      child: ListTile(
                        onTap: () async {
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => DeckView(
                                initialDeck: deck,
                              ),
                            ),
                          );
                        },
                        leading: SizedBox(
                          child: FactionIcon(
                            faction: deck.faction,
                            colorFilter: ColorFilter.mode(
                              deck.faction.theme.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          width: 24,
                          height: 24,
                        ),
                        title: Text(
                          '${deck.cards.length} Cards',
                        ),
                        subtitle: Text(
                          '${timeago.format(time).capitalize()}\n'
                          '$preview, ...',
                        ),
                        isThreeLine: true,
                        trailing: Icon(Icons.file_open),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: decks.length,
                );
              },
            ),
          ),

          // Buttons
          ButtonBar(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final deck = await import();
                  if (deck == null) {
                    return;
                  }
                  await Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => DeckView(
                        initialDeck: deck,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.upload_file),
                label: Text('Pick file'),
              ),
            ],
          )
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
    return Container(
      child: Row(
        mainAxisAlignment: _mainAxisAlignment,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

final class _ConfigureRandomSheet extends StatefulWidget {
  const _ConfigureRandomSheet();

  @override
  State<StatefulWidget> createState() => _ConfigureRandomSheetState();
}

final class _ConfigureRandomSheetState extends State<_ConfigureRandomSheet> {
  late Faction faction;
  late List<GalaxyCard> galaxyRow;
  var balancedStart = true;

  void _shuffle() {
    final random = Random();
    faction = random.nextBool() ? Faction.rebel : Faction.imperial;

    // Create a (shuffled) galaxy deck.
    final galaxy = CardDefinitions.instance.galaxyRowDeck().toList()
      ..shuffle(random);

    // Pick the first 6 cards.
    // If it's a balanced start, pick 2 of each faction.
    galaxyRow = balancedStart
        ? [
            ...galaxy.where((card) => card.faction == Faction.rebel).take(2),
            ...galaxy.where((card) => card.faction == Faction.imperial).take(2),
            ...galaxy.where((card) => card.faction == Faction.neutral).take(2),
          ]
        : galaxy.take(6).toList();
  }

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Header
          Text(
            'Random Start',
            style: theme.textTheme.titleSmall,
          ),

          // Faction
          ListView(
            shrinkWrap: true,
            children: [
              // Faction.
              ListTile(
                title: Text('Faction'),
                trailing: SegmentedButton<Faction>(
                  segments: [
                    ButtonSegment(
                      value: Faction.imperial,
                      icon: SizedBox(
                        width: 16,
                        height: 16,
                        child: FactionIcon(
                          faction: Faction.imperial,
                          colorFilter: ColorFilter.mode(
                            Faction.imperial.theme.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: Text('Empire'),
                    ),
                    ButtonSegment(
                      value: Faction.rebel,
                      icon: SizedBox(
                        width: 16,
                        height: 16,
                        child: FactionIcon(
                          faction: Faction.rebel,
                          colorFilter: ColorFilter.mode(
                            Faction.rebel.theme.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: Text('Rebels'),
                    ),
                  ],
                  selected: {
                    faction,
                  },
                  showSelectedIcon: false,
                  onSelectionChanged: (faction) {
                    setState(() {
                      if (faction.isNotEmpty) {
                        this.faction = faction.single;
                      }
                    });
                  },
                ),
              ),
            ],
          ),

          CheckboxListTile(
            title: Text('Balanced Start'),
            value: balancedStart,
            onChanged: (value) {
              setState(() {
                balancedStart = value ?? false;
              });
            },
          ),

          // Galaxy Row (6 cards)
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Galaxy Row'),
                Text(
                  'Suggestions',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // All 6 cards.
                ...galaxyRow.map(
                  (card) => Text(card.title),
                ),
              ],
            ),
          ),

          // Buttons
          ButtonBar(
            children: [
              TextButton(
                child: const Text('Shuffle'),
                onPressed: () {
                  setState(_shuffle);
                },
              ),
              TextButton(
                child: const Text('Accept'),
                onPressed: () => Navigator.of(context).pop(Deck(
                  faction: faction,
                  cards: faction == Faction.rebel
                      ? CardDefinitions.instance.rebelStarterDeck()
                      : CardDefinitions.instance.imperialStarterDeck(),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
