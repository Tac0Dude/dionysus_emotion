# Backend Supabase — partage co-parent

## Mise en place (à faire une fois)
1. Créer un projet sur https://supabase.com (noter **Project URL** et **anon public key**
   dans Project Settings > API).
2. **Auth > Providers** : activer **Anonymous sign-ins**.
3. **SQL Editor** : coller et exécuter [`setup.sql`](./setup.sql).
4. **Database > Replication** (ou Realtime) : activer Realtime sur la table
   `public.shared_entries`.
5. Reporter l'URL et la clé anon dans `lib/config/supabase_config.dart`.

> La clé `anon` est publique par conception : la sécurité repose entièrement sur le
> Row Level Security défini dans `setup.sql`.

## Modèle
- `profiles` : un par utilisateur (auth anonyme). `pairing_code` est encodé dans le QR.
- `shared_entries` : projeté dénormalisé des saisies (émotion, quadrant, intensité, date).
  Unicité `(owner_id, client_entry_id)` → synchro idempotente.
- RPC `link_coparent(target_id, target_code)` / `unlink_coparent()` : appairage symétrique.
- RLS : on ne lit que ses propres données **ou** celles de son co-parent appairé.

## Vérifier le RLS
Avec un 3e utilisateur non appairé, `select * from shared_entries` ne doit renvoyer
que ses propres lignes (aucune de A ou B).
