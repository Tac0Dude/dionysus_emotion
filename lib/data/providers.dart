import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/parent.dart';
import '../domain/repositories/entry_repository.dart';
import '../domain/repositories/parent_repository.dart';
import '../domain/repositories/reference_repository.dart';
import 'database/app_database.dart';
import 'history/history_seen_service.dart';
import 'repositories/entry_repository_impl.dart';
import 'repositories/parent_repository_impl.dart';
import 'repositories/reference_repository_impl.dart';

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
