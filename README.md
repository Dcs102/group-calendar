# Group Calendar (Supabase, no server to run)

A single-file, real-time shared calendar. Host the `index.html` anywhere static
(GitHub Pages is used here), point it at a free Supabase project, and share the link.

## Files
- `index.html`  - the whole app (UI + Supabase client + realtime sync).
- `supabase-setup.sql` - create the `events` table, open RLS policies, enable realtime.
- `.github/workflows/supabase-heartbeat.yml` - daily ping so free Supabase never pauses.

## Setup (one time)
1. **Supabase** - create a free project at https://supabase.com.
   In the SQL Editor, paste & run `supabase-setup.sql`.
2. Grab your **Project URL** and **anon public key** from Project Settings -> API.
3. Put those two values into:
   - `index.html`  (the `CONFIG` block near the top of the `<script>`)
   - `.github/workflows/supabase-heartbeat.yml` (the curl line)
4. **Host** - push this folder to a GitHub repo and enable Pages
   (Settings -> Pages -> deploy from branch). Share the `https://<user>.github.io/<repo>/` URL.

## Notes
- Anyone with the link can add / edit / delete events (open RLS, no login). Add your
  optional name so people know who added what.
- Changes appear in other open tabs within ~1 second via Supabase Realtime.
- The daily keep-alive keeps the free project from pausing after a week of quiet.
