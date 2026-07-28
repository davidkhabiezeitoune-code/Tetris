# Sleep & Settling Tracker

A read-only dashboard that turns your baby sleep-log Google Sheet into charts,
KPIs, and a searchable session table — no account, no database, no backend.
You keep logging sessions the way you already do, directly in the Sheet (or
via its mobile app); this page just reads it live and visualizes it.

## Setup (one step)

Open the spreadsheet → **Share** (top right) → change access to **"Anyone
with the link" → Viewer**. That's it — the app reads the sheet's public CSV
export directly from the browser, no API key needed.

The sheet ID is already wired into `index.html` (`SHEET_ID` near the top of
the `<script>` block). If you ever copy this app to track a different sheet,
that's the only thing to change.

## Why read-only

Google only allows *writes* to a sheet from someone logged in editing it
directly, or from a Google Form's public submission endpoint — there's no
way to accept writes from an anonymous web page without a login somewhere.
Rather than requiring an account for that, the app leans into what already
works with zero setup: you and the other carers keep adding rows in the
actual Google Sheet (using the Sheets app, which is built for exactly this),
and the dashboard reflects it within about 30 seconds — no separate "backend"
to maintain, ever.

The **Log a session** button in the header just opens the sheet directly for
you to add a row.

## Column format

The app looks for columns by header keyword (case-insensitive), so it's
tolerant of re-wording, but expects roughly:

| Column (header contains…) | Example |
|---|---|
| `date` | `6 July` or `7/6/2026` |
| `time` | `12:10-12:15` (settling start–end; a single time like `12:10` is fine too, it just won't have a computed duration) |
| `event`/`type` | `Nap time`, `Bedtime`, `Night wake-up` |
| `carer` | `Rosie`, `Dave`, `Pia`, or `-` for self-settled |
| `settled`/`method` | free text |
| `notes` | free text |

Time ranges that cross midnight (e.g. `23:30-1:30`) are handled correctly.

## Hosting it

To access it from everyone's phone, either:

- **GitHub Pages**: enable Pages for this repo (Settings → Pages → deploy from
  branch), then share `https://<user>.github.io/<repo>/baby-sleep-tracker/`.
- Or host the file anywhere that serves static files.

## Features

- **Live read** from the Sheet — polls every ~30s, no login.
- Charts: settle time per session, average settle time by type, who settles
  which events, night wake-ups by day, typical time of day per event type,
  common settling techniques (extracted from the "how he settled" text).
- KPI tiles: sessions logged, average settle time, night wake-ups in the last
  7 days, most active carer.
- Filter by date range, event type, carer, or free-text search.
- Sortable session table.
- CSV export of the parsed data.
- Light/dark theme (follows system, or toggle manually).
- **AI Insights tab** — sends a summary of the log directly to Claude
  (Anthropic's AI) from the browser and shows back patterns and suggestions.

### AI Insights — how it works, and the tradeoff

This is the one feature that isn't purely read-only: generating insights
makes an outbound API call. Since there's no backend, it uses **your own
Anthropic API key**, entered once on the Insights tab and stored only in
that browser's `localStorage`.

Browsers can't call `api.anthropic.com` directly — it doesn't return the
CORS headers a cross-origin `fetch()` needs, so the request has to go
through a tiny relay first. `cloudflare-worker.js` in this folder is that
relay: a stateless pass-through that reads the API key off each request and
forwards it straight to Anthropic, storing nothing itself. It's about the
smallest thing that can sit in the middle.

**One-time setup (a couple of minutes, easiest on a laptop):**

1. Sign up free at [dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up) — no credit card needed.
2. In the dashboard: **Workers & Pages** → **Create** → **Create Worker**. Give it any name (e.g. `sleep-tracker-relay`) and click **Deploy** to create the default worker.
3. Click **Edit code**, delete the placeholder content, and paste in the contents of `cloudflare-worker.js` from this folder. Click **Save and deploy**.
4. Copy the worker's URL — it looks like `https://sleep-tracker-relay.<your-subdomain>.workers.dev`.
5. Open the app's **Insights** tab, paste that URL into **Relay URL**, paste your Anthropic API key into **Anthropic API key** (get one at [console.anthropic.com](https://console.anthropic.com/settings/keys)), and tap **Save & continue**.

Both values are saved only in that browser's `localStorage` — the key is
visible in that page's network requests (to the relay, and from the relay
on to Anthropic), since there's no backend of the app's own to hide it
behind. This is a deliberate tradeoff, acceptable specifically because this
app is only ever shared as a private link with people you trust — don't
reuse this pattern for anything public.

## Limitations

- **No in-app editing.** Fixing or removing a logged session happens in the
  actual Google Sheet (tap **Log a session** to jump there).
- **~30s lag**, not instant — there's no live-push for Sheets the way a real
  database has.
- If the sheet's sharing gets changed back to restricted, the app shows a
  clear "can't reach sheet" banner rather than failing silently.
