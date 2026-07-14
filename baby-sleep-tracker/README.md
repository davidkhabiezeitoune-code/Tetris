# Sleep & Settling Tracker

A web app that turns a baby sleep-log spreadsheet into a shared dashboard: a
session log (nap/bedtime/night-wake-up), settle-time analytics, and a form for
logging new sessions — synced live across every carer's device via Supabase.

## Setup (mobile-friendly, no SQL required)

1. Create a free project at [supabase.com](https://supabase.com) — a few taps,
   no code.
2. **Create the table** — open your project, tap **Table Editor** in the left
   sidebar → **New table**. Name it `sessions`, leave "Enable Row Level
   Security" checked, and add these columns (tap **+ New column** for each —
   `id` and `created_at` already exist by default, don't touch those):

   | Name | Type | Nullable? |
   |---|---|---|
   | `date` | `date` | No |
   | `start_time` | `time` | No |
   | `end_time` | `time` | Yes |
   | `event_type` | `text` | No |
   | `carer` | `text` | Yes |
   | `method` | `text` | Yes |
   | `notes` | `text` | Yes |

   Tap **Save**.

3. **Allow the app to read/write it** — since there's no login (see "Access
   model" below), every carer connects with the same public "anon" key, so the
   table needs policies that let that key do everything. Tap the table's
   **Policies** tab (or **Authentication → Policies**) → **New Policy** →
   pick the **quickstart template** for enabling access to everyone / all
   users, apply it, and save. Do this once each for **select**, **insert**,
   **update**, and **delete** (some templates cover all four at once — either
   is fine).

4. **Turn on live sync** — still in Table Editor, open the `sessions` table's
   `•••` menu (or **Database → Replication**) and toggle **Realtime** on for
   this table. This is what makes a session logged on one phone show up on
   everyone else's without a refresh — the app also polls every 45s as a
   backup if this step gets skipped.

5. **Get your keys** — tap **Settings → API**. Copy the **Project URL** and
   the **anon / public key** (short strings, easy to copy individually).

6. Open `index.html`, find these two lines near the top of the `<script>`
   block, and paste your values in:
   ```js
   var SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
   var SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
   ```

7. Reload the page. The status pill in the header should read **● Synced**,
   and since the table is empty, you'll see a banner offering to **load the
   19 sample sessions** from the original spreadsheet with one tap — no SQL
   needed for that either.

If you're on a laptop/desktop at some point, [`supabase/schema.sql`](supabase/schema.sql)
does all of the above (table, policies, realtime, seed data) in one paste into
the SQL Editor — a shortcut, not a requirement.

## Access model

There's no login. Anyone with the page URL can read and log sessions — the
anon key is safe to embed in the page (that's how Supabase is designed to be
used; access is controlled by the policies from step 3, not by keeping the
key secret). Treat the page URL itself as the thing you keep private, the
same way you'd treat a shared link to a private document.

## Hosting it

To access it from everyone's phone, either:

- **GitHub Pages**: enable Pages for this repo (Settings → Pages → deploy from
  branch), then share `https://<user>.github.io/<repo>/baby-sleep-tracker/`.
- Or host the file anywhere that serves static files.

## Features

- Log sessions: date, event type (nap/bedtime/night wake-up/custom), start &
  end time, carer, settling method, notes.
- **Live sync** — a session logged on one phone appears on everyone else's
  within moments (realtime, with a 45s poll as a fallback).
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
