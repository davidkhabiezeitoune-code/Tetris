# Sleep & Settling Tracker

A web app that turns a baby sleep-log spreadsheet into a shared dashboard: a
session log (nap/bedtime/night-wake-up), settle-time analytics, and a form for
logging new sessions — synced live across every carer's device via Supabase.

## Setup (one-time, ~5 minutes)

1. Create a free project at [supabase.com](https://supabase.com).
2. In your project, open **SQL Editor → New query**, paste the contents of
   [`supabase/schema.sql`](supabase/schema.sql), and run it. This creates the
   `sessions` table, opens it up to the shared link (no login — see below),
   turns on realtime sync, and seeds it with the 19 sessions from the original
   spreadsheet (6–13 July).
3. Go to **Settings → API** and copy the **Project URL** and the **anon /
   public key**.
4. Open `index.html`, find these two lines near the top of the `<script>`
   block, and paste your values in:
   ```js
   var SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
   var SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
   ```
5. Reload the page — the status pill in the header should read **● Synced**.

Until step 4 is done, the app shows a banner and won't try to load or save
data (there's nothing to connect to yet).

## Access model

There's no login. Anyone with the page URL can read and log sessions — the
anon key is safe to embed in the page (that's how Supabase is designed to be
used; access is controlled by the RLS policies in `schema.sql`, not by
keeping the key secret). Treat the page URL itself as the thing you keep
private, the same way you'd treat a shared link to a private document.

## Hosting it

To access it from everyone's phone, either:

- **GitHub Pages**: enable Pages for this repo (Settings → Pages → deploy from
  branch), then share `https://<user>.github.io/<repo>/baby-sleep-tracker/`.
- Or host the file anywhere that serves static files.

## Features

- Log sessions: date, event type (nap/bedtime/night wake-up/custom), start &
  end time, carer, settling method, notes.
- **Live sync** — a session logged on one phone appears on everyone else's
  within moments, no refresh needed.
- Auto-computed settle duration, including overnight wake-ups that cross
  midnight.
- Charts: settle time per session, average settle time by type, who settles
  which events, night wake-ups by day, common settling techniques (extracted
  from the "how he settled" text).
- Filter by date range, event type, carer, or free-text search.
- Sortable session table with inline edit/delete.
- CSV export.
- Light/dark theme (follows system, or toggle manually).

## Data ownership

Your sleep log lives in your own Supabase project — not on any Anthropic or
third-party server tied to this repo. You can export it anytime (Export CSV),
inspect/query it directly in the Supabase dashboard, or delete the project to
erase everything.
