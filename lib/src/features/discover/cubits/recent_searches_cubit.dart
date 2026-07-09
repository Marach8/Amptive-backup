import 'dart:convert';

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/discover/data/models/recent_search_entry.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the user's recent searches, persisted locally. Entries are added
/// when a search result is opened, newest first, deduped by type+id and
/// capped at [_maxEntries].
class RecentSearchesCubit extends Cubit<List<RecentSearchEntry>>
    with SafeEmit<List<RecentSearchEntry>> {
  RecentSearchesCubit({ATLocalStorageService? mockLocalStorageService})
      : localStorageService =
            mockLocalStorageService ?? FlutterSecureStorageServiceImpl(),
        super(const <RecentSearchEntry>[]) {
    _load();
  }

  static const String _baseStorageKey = 'recent_searches';
  static const int _maxEntries = 15;

  final ATLocalStorageService localStorageService;

  /// Per-account storage key, resolved during [_load] so one account never
  /// sees another account's search history.
  String _storageKey = _baseStorageKey;

  Future<void> _load() async {
    try {
      final dynamic cachedUser =
          await localStorageService.getObject(ATStrings.cachedUserData);
      final String? userId =
          cachedUser is Map ? cachedUser[ATStrings.userId] as String? : null;
      if (userId != null && userId.isNotEmpty) {
        _storageKey = '${_baseStorageKey}_$userId';
        // Delete the old shared (account-agnostic) history so it can't
        // leak between accounts.
        await localStorageService.remove(_baseStorageKey);
      }

      final String? raw = await localStorageService.get(_storageKey);
      if (raw == null || raw.isEmpty) return;
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      emit(decoded
          .map((dynamic e) =>
              RecentSearchEntry.fromJson(e as Map<String, dynamic>))
          .toList());
    } catch (e) {
      debugPrint('Failed to load recent searches: $e');
    }
  }

  Future<void> _persist(List<RecentSearchEntry> entries) async {
    try {
      await localStorageService.set(
        _storageKey,
        jsonEncode(
            entries.map((RecentSearchEntry e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Failed to persist recent searches: $e');
    }
  }

  void add(RecentSearchEntry entry) {
    if (entry.title.trim().isEmpty) return;
    final List<RecentSearchEntry> updated = <RecentSearchEntry>[
      entry,
      ...state.where((RecentSearchEntry e) =>
          !(e.type == entry.type && e.id == entry.id)),
    ].take(_maxEntries).toList();
    emit(updated);
    _persist(updated);
  }

  void remove(RecentSearchEntry entry) {
    final List<RecentSearchEntry> updated = state
        .where((RecentSearchEntry e) =>
            !(e.type == entry.type && e.id == entry.id))
        .toList();
    emit(updated);
    _persist(updated);
  }

  void clear() {
    emit(const <RecentSearchEntry>[]);
    _persist(const <RecentSearchEntry>[]);
  }
}
