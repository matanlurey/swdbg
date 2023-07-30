part of '../views.dart';

/// View that displays the changelog.
final class ChangelogView extends StatelessWidget {
  /// Create a new changelog view.
  const ChangelogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Center(
        child: FutureBuilder(
          // ignore: discarded_futures
          future: DefaultAssetBundle.of(context).loadString(
            'assets/changelog.md',
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                data: snapshot.data!,
                shrinkWrap: true,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
