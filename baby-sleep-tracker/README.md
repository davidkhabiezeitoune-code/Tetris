# Sleep & Settling Tracker

A single-file web app that turns a baby sleep-log spreadsheet into a dashboard: a
session log (nap/bedtime/night-wake-up), settle-time analytics, and a form for
logging new sessions.

It's pre-seeded with the 19 sessions from the original spreadsheet (6–13 July).

## Using it

Open `index.html` in any browser — no build step, no server, no dependencies.
Data is stored in the browser's `localStorage`, so:

- It's private to that browser/device.
- Use **Export CSV** regularly to back up your data or move it to another device.
- Clearing browser data/cache will erase it.

## Hosting it

To access it from your phone, either:

- **GitHub Pages**: enable Pages for this repo (Settings → Pages → deploy from
  branch), then visit `https://<user>.github.io/<repo>/baby-sleep-tracker/`.
- Or just open the file locally / host it anywhere that serves static files.

## Features

- Log sessions: date, event type (nap/bedtime/night wake-up/custom), start &
  end time, carer, settling method, notes.
- Auto-computed settle duration, including overnight wake-ups that cross
  midnight.
- Charts: settle time per session, average settle time by type, who settles
  which events, night wake-ups by day, common settling techniques (extracted
  from the "how he settled" text).
- Filter by date range, event type, carer, or free-text search.
- Sortable session table with inline edit/delete.
- CSV export.
- Light/dark theme (follows system, or toggle manually).
