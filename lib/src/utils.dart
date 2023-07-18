/// String extensions.
extension Strings on String {
  static final _camel = RegExp('(?=[A-Z])');

  /// Return with the first character capitalized.
  String capitalize() {
    return substring(0, 1).toUpperCase() + substring(1);
  }

  /// Return with each word capitalized.
  String toTitleCase() {
    return split(' ').map((s) => s.capitalize()).join(' ');
  }

  /// Returns converted from camel case to title case.
  String camelToTitleCase() {
    return split(_camel).map((s) => s.capitalize()).join(' ');
  }
}
