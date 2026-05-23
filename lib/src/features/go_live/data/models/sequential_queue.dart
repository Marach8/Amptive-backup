import 'dart:async';
import 'dart:collection';

class SequentialQueue<T> {
  SequentialQueue({
    required this.onItem,
    this.delay = const Duration(milliseconds: 300),
    this.maxSize,
  });

  final FutureOr<void> Function(T item) onItem;
  final Duration delay;
  final int? maxSize;

  final Queue<T> _queue = Queue<T>();
  bool _isDraining = false;
  bool _isDisposed = false;

  /// Add item to queue
  void add(T item) {
    if (_isDisposed) return;

    _queue.addLast(item);

    // optional cap (prevents memory explosion)
    if (maxSize != null && _queue.length > maxSize!) {
      _queue.removeFirst();
    }

    _drain();
  }

  /// Add multiple items
  void addAll(Iterable<T> items) {
    if (_isDisposed) return;

    for (final T item in items) {
      add(item);
    }
  }

  /// Core draining logic
  Future<void> _drain() async {
    if (_isDraining || _isDisposed) return;

    _isDraining = true;

    while (_queue.isNotEmpty && !_isDisposed) {
      final T item = _queue.removeFirst();

      try {
        await onItem(item);
      } catch (_) {
        // swallow or log if needed
      }

      await Future<void>.delayed(delay);
    }

    _isDraining = false;
  }

  /// Clear queue
  void clear() {
    _queue.clear();
  }

  /// Dispose safely
  void dispose() {
    _isDisposed = true;
    _queue.clear();
  }

  /// Helpers
  bool get isEmpty => _queue.isEmpty;
  int get length => _queue.length;
}
