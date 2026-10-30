# Cladder & Co Production Tracker

A browser-based production tracker for fabric inventory, cutting batches, stage movement, outsourcing, incoming receipts, and accessory stock.

## Supabase Setup

1. Open your Supabase project SQL editor.
2. Run `supabase-setup.sql` once.
3. If the database already exists, run `supabase-security-hardening.sql` once to remove anonymous write/RPC access.
4. Open `index.html` in a browser or use the GitHub Pages URL.

The app stores a full tracker snapshot in the `production_tracker_state` table, mirrors fabric inventory into `public.fabrics`, and also keeps a browser `localStorage` backup.

## GitHub Safety

`supabase-config.js` contains the original project browser configuration. GitHub Pages generates this file from the `SUPABASE_URL` and `SUPABASE_ANON_KEY` repository variables. The Supabase anon key used by the browser app is public by design; never commit a Supabase `service_role` key. Database writes are expected to require a signed-in Supabase Auth user.

## Cladder & Co deployment

Live dashboard: https://saumay-spec.github.io/Cladder-Co/

The dashboard uses the original Supabase project and shared tracker snapshot, so changes after login also affect the original tracker. The allowed login is `20saumay04@gmail.com`; a Supabase project administrator must ensure this address exists in Authentication > Users. Changing the dashboard allowlist does not create a Supabase Auth user or grant database access. Keep signups disabled and confirm the project database policies before adding users.

Opening the app loads shared entries without writing them back. If the initial cloud load fails, automatic cloud saves stay disabled until a successful reconnect. Existing browser backup keys are retained.
