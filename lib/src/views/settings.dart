part of '../views.dart';

/// A view that displays the user's settings.
final class SettingsView extends StatefulWidget {
  /// The user's preferences.
  final SharedPreferences preferences;

  /// Create a new settings view.
  const SettingsView({
    required this.preferences,
    super.key,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late bool _enableExperimentalInsights;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Present a form with a single check box for a flag.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Form(
        child: ListView(
          children: [
            FutureBuilder<bool>(
              // ignore: discarded_futures
              future: enableExperimentalInsights.get(widget.preferences),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _enableExperimentalInsights = snapshot.data!;
                  return CheckboxListTile(
                    title: const Text('Enable Experimental Insights'),
                    value: _enableExperimentalInsights,
                    onChanged: (value) async {
                      await enableExperimentalInsights.set(
                        widget.preferences,
                        value ?? false,
                      );
                      setState(() {
                        _enableExperimentalInsights = value ?? false;
                      });
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
