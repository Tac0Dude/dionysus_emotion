import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/parent.dart';
import '../domain/repositories/entry_repository.dart';
import '../domain/repositories/parent_repository.dart';
import '../domain/repositories/coparent_repository.dart';
import '../domain/repositories/reference_repository.dart';
import 'database/app_database.dart';
import 'history/history_seen_service.dart';
import 'repositories/coparent_repository_impl.dart';
import 'repositories/entry_repository_impl.dart';
import 'repositories/parent_repository_impl.dart';
import 'repositories/reference_repository_impl.dart';
import 'sync/shared_entry_sync.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final parentRepositoryProvider = Provider<ParentRepository>((ref) {
  return ParentRepositoryImpl(ref.watch(databaseProvider));
});

final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  return EntryRepositoryImpl(ref.watch(databaseProvider));
});

final referenceRepositoryProvider = Provider<ReferenceRepository>((ref) {
  return ReferenceRepositoryImpl(ref.watch(databaseProvider));
});

final currentParentProvider = StreamProvider<Parent?>((ref) {
  return ref.watch(parentRepositoryProvider).watchCurrentParent();
});

final historySeenServiceProvider = Provider<HistorySeenService>((ref) {
  return HistorySeenService();
});

final coparentRepositoryProvider = Provider<CoparentRepository>((ref) {
  return CoparentRepositoryImpl();
});

final sharedEntrySyncProvider = Provider<SharedEntrySync>((ref) {
  return SharedEntrySync(
    coparent: ref.watch(coparentRepositoryProvider),
    entries: ref.watch(entryRepositoryProvider),
    parents: ref.watch(parentRepositoryProvider),
    reference: ref.watch(referenceRepositoryProvider),
  );
});

/// Id du co-parent appairé (ou null), en temps réel.
final coparentIdProvider = StreamProvider<String?>((ref) {
  return ref.watch(coparentRepositoryProvider).watchCoparentId();
});
