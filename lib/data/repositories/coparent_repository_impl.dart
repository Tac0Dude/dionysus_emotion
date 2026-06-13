import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/supabase_config.dart';
import '../../domain/entities/coparent_profile.dart';
import '../../domain/entities/shared_emotion.dart';
import '../../domain/repositories/coparent_repository.dart';

class CoparentRepositoryImpl implements CoparentRepository {
  static const _profiles = 'profiles';
  static const _sharedEntries = 'shared_entries';

  /// Client Supabase, ou null si le backend n'est pas configuré/initialisé.
  SupabaseClient? get _client {
    if (!SupabaseConfig.isConfigured) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  @override
  bool get isAvailable => currentUserId != null;

  @override
  String? get currentUserId => _client?.auth.currentUser?.id;

  @override
  Future<void> ensureProfile(String firstName) async {
    final client = _client;
    final uid = currentUserId;
    if (client == null || uid == null) return;
    // Upsert partiel : à la création, pairing_code prend sa valeur par défaut ;
    // en conflit, on ne touche qu'au prénom.
    await client.from(_profiles).upsert(
      {'id': uid, 'first_name': firstName},
      onConflict: 'id',
    );
  }

  @override
  Future<String?> myPairingPayload() async {
    final client = _client;
    final uid = currentUserId;
    if (client == null || uid == null) return null;
    final row = await client
        .from(_profiles)
        .select('pairing_code')
        .eq('id', uid)
        .maybeSingle();
    final code = row?['pairing_code'] as String?;
    if (code == null) return null;
    return '$uid:$code';
  }

  @override
  Future<CoparentLinkResult> linkWith(String scannedPayload) async {
    final client = _client;
    if (client == null) return CoparentLinkResult.notReady;

    final sep = scannedPayload.indexOf(':');
    if (sep <= 0 || sep == scannedPayload.length - 1) {
      return CoparentLinkResult.invalidCode;
    }
    final targetId = scannedPayload.substring(0, sep);
    final targetCode = scannedPayload.substring(sep + 1);

    try {
      await client.rpc('link_coparent', params: {
        'target_id': targetId,
        'target_code': targetCode,
      });
      return CoparentLinkResult.success;
    } on PostgrestException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid pairing code')) {
        return CoparentLinkResult.invalidCode;
      }
      if (msg.contains('already paired')) return CoparentLinkResult.alreadyPaired;
      if (msg.contains('yourself')) return CoparentLinkResult.selfPair;
      return CoparentLinkResult.error;
    } catch (_) {
      return CoparentLinkResult.error;
    }
  }

  @override
  Future<void> unlink() async {
    final client = _client;
    if (client == null) return;
    await client.rpc('unlink_coparent');
  }

  @override
  Future<void> deleteMyData() async {
    final client = _client;
    final uid = currentUserId;
    if (client == null || uid == null) return;
    // Rompt d'abord l'appairage (révoque l'accès du co-parent), puis efface.
    await client.rpc('unlink_coparent');
    await client.from(_sharedEntries).delete().eq('owner_id', uid);
  }

  @override
  Stream<String?> watchCoparentId() {
    final client = _client;
    final uid = currentUserId;
    if (client == null || uid == null) return Stream.value(null);
    return client
        .from(_profiles)
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .map((rows) =>
            rows.isEmpty ? null : rows.first['coparent_id'] as String?);
  }

  @override
  Future<CoparentProfile?> getProfile(String id) async {
    final client = _client;
    if (client == null) return null;
    final row = await client
        .from(_profiles)
        .select('id, first_name')
        .eq('id', id)
        .maybeSingle();
    if (row == null) return null;
    return CoparentProfile(
      id: row['id'] as String,
      firstName: (row['first_name'] as String?) ?? '',
    );
  }

  @override
  Stream<List<SharedEmotion>> watchSharedEntries(String ownerId) {
    final client = _client;
    if (client == null) return Stream.value(const []);
    return client
        .from(_sharedEntries)
        .stream(primaryKey: ['id'])
        .eq('owner_id', ownerId)
        .order('created_at')
        .map((rows) => rows
            .map((r) => SharedEmotion(
                  emotionName: r['emotion_name'] as String,
                  quadrantLabel: r['quadrant_label'] as String,
                  intensity: r['intensity'] as int,
                  createdAt: DateTime.parse(r['created_at'] as String),
                ))
            .toList());
  }

  @override
  Future<void> pushEntries(List<SharedEntryUpload> entries) async {
    final client = _client;
    final uid = currentUserId;
    if (client == null || uid == null || entries.isEmpty) return;
    final rows = entries
        .map((e) => {
              'owner_id': uid,
              'client_entry_id': e.clientEntryId,
              'emotion_name': e.emotionName,
              'quadrant_label': e.quadrantLabel,
              'intensity': e.intensity,
              'created_at': e.createdAt.toIso8601String(),
            })
        .toList();
    await client
        .from(_sharedEntries)
        .upsert(rows, onConflict: 'owner_id,client_entry_id');
  }
}
