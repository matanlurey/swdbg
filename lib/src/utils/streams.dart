part of '../utils.dart';

/// Stream extensions.
extension Streams<T> on Stream<T> {
  /// Returns a stream of events where the event is of type [E].
  Stream<E> whereType<E extends T>() => where((e) => e is E).cast<E>();
}
