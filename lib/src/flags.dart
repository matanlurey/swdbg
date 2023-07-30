import 'package:shared_preferences/shared_preferences.dart';

/// Whether to enable experimental insights.
final enableExperimentalInsights = Flag._(
  defaultValue: false,
  preferenceKey: 'enableExperimentalInsights',
);

/// A flag is used to store global configuration.
final class Flag {
  /// The default value of the flag.
  final bool defaultValue;

  /// Key used to store the flag in shared preferences.
  final String preferenceKey;

  /// Create a new flag.
  const Flag._({
    required this.defaultValue,
    required this.preferenceKey,
  });

  /// Get the value of the flag.
  Future<bool> get(SharedPreferences preferences) async {
    return preferences.getBool(preferenceKey) ?? defaultValue;
  }

  /// Set the value of the flag.
  // ignore: avoid_positional_boolean_parameters
  Future<void> set(SharedPreferences preferences, bool value) async {
    await preferences.setBool(preferenceKey, value);
  }
}
