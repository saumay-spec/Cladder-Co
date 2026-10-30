# Cladder & Co Production Tracker

A browser-based production tracker for fabric inventory, cutting batches, stage movement, outsourcing, incoming receipts, and accessory stock.

## Supabase Setup

The Cladder & Co project is `wiuetyoobzbhvsartwis` (Mumbai). Its ten tables and atomic relational sync function were created using `cladder-schema.sql`. Apply `cladder-public-access.sql` afterward to enable the owner-requested public viewing and editing. This is a fresh-project schema, not an existing-database migration.

The dashboard opens directly without sign-in. At the owner's explicit request, both anonymous visitors and authenticated users can read, add, change, and delete tracker data. RLS remains enabled, with public access policies on the ten application tables; the sync function remains security invoker. No passwords or privileged server keys are used by the dashboard.

GitHub Pages builds its browser config from repository variables `SUPABASE_URL` and `SUPABASE_ANON_KEY`. Only a publishable/anon key belongs in these variables, never a secret/service-role key.

This project starts with empty inventories and production records. To migrate historical entries, export JSON from the original dashboard and import it after signing in to Cladder & Co. The original Supabase project is not accessible to this connected account.

## GitHub Safety

`supabase-config.js` contains the Cladder & Co project browser configuration. GitHub Pages generates this file from the `SUPABASE_URL` and `SUPABASE_ANON_KEY` repository variables. The Supabase anon key used by the browser app is public by design; never commit a Supabase `service_role` key. Database writes are expected to require a signed-in Supabase Auth user.

## Cladder & Co deployment

Live dashboard: https://saumay-spec.github.io/Cladder-Co/

GitHub Pages is the primary public host. A fallback dashboard is also available at https://cladder-co-workspace.royaltrail1024.chatgpt.site and uses the same Supabase project.

Cladder & Co now uses its own Supabase project, independently of the original tracker. The browser backup key is specific to this project so old preview data cannot be confused with the new inventory.

Opening the app reads the shared entries without writing them back. If cloud loading fails, automatic cloud saves stay disabled until a successful reconnect.
