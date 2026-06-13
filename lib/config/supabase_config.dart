/// Configuration Supabase (partage co-parent).
///
/// La clé `anon` est publique par conception (destinée au client) : la sécurité
/// repose sur le Row Level Security défini dans `supabase/setup.sql`.
///
/// Renseigner les valeurs du projet (Project Settings > API), ou les fournir au
/// build via `--dart-define` (elles ont alors la priorité).
class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://fvhvnykrdmplputfdgve.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2aHZueWtyZG1wbHB1dGZkZ3ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEzNDgzODEsImV4cCI6MjA5NjkyNDM4MX0.b24lJqjtgigXbHTOw1aWSIJN1xW9cDhMsk66gq2m2oQ',
  );

  /// Vrai si des valeurs réelles ont été fournies : permet à l'app de continuer
  /// à fonctionner en local (sans co-parent) tant que le backend n'est pas câblé.
  static bool get isConfigured =>
      !url.contains('YOUR-PROJECT') && !anonKey.contains('YOUR-ANON');
}
