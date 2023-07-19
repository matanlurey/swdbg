part of '../widgets.dart';

/// Shows the changelog.
final class ChangelogDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        content: FutureBuilder(
          // ignore: discarded_futures
          future: DefaultAssetBundle.of(context).loadString(
            'assets/changelog.md',
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: 300,
                child: Markdown(
                  data: snapshot.data!,
                  shrinkWrap: true,
                ),
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
