-- Sleep & Settling Tracker — Supabase schema
-- Run this once in your Supabase project's SQL editor (Database > SQL Editor > New query).

create table if not exists sessions (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  start_time time not null,
  end_time time,
  event_type text not null,
  carer text,
  method text,
  notes text,
  created_at timestamptz not null default now()
);

-- Row Level Security is required for the anon (public) key to be able to
-- touch this table at all. Since this app uses a shared link with no login
-- (anyone with the link can read/write), the policies below simply allow
-- every operation for anyone holding the anon key.
alter table sessions enable row level security;

create policy "public read" on sessions
  for select using (true);
create policy "public insert" on sessions
  for insert with check (true);
create policy "public update" on sessions
  for update using (true);
create policy "public delete" on sessions
  for delete using (true);

-- Enable realtime so every device sees changes made on another device live.
alter publication supabase_realtime add table sessions;

-- Seed data from the original spreadsheet (6-13 July).
insert into sessions (date, start_time, end_time, event_type, carer, method, notes) values
  ('2026-07-06', '12:10', '12:15', 'Nap', 'Rosie', 'Quick cuddle, put down awake, pat to sleep circa 5 mins', 'Wanted to be put down'),
  ('2026-07-06', '19:30', '20:00', 'Bedtime', 'Dave', 'Rock to sleep; transfer deeply asleep', 'Tried rocking to transfer drowsy but didn''t work; first 1 nap day, should have been tired'),
  ('2026-07-06', '23:30', '01:30', 'Night wake-up', 'Dave', 'Floorbed co-sleeping', 'Wake up reason unknown; attempted 10min CIO then would fall asleep quickly on Dave but not transfer; first day of successful 1 day nap day'),
  ('2026-07-07', '12:10', '12:15', 'Nap', 'Rosie', 'Quick cuddle, put down drowsy, pat to sleep', 'Was being wriggly and pointing at door, gently rocked him till rubbing eyes (circa 2/3 mins) put down drowsy and then firm pats and shush for a couple mins till asleep'),
  ('2026-07-07', '19:30', '19:35', 'Bedtime', 'Dave', 'Rocked to sleep but it only took two minutes of hypnotist voice. Cuddled on chair then transferred asleep', null),
  ('2026-07-08', '12:10', null, 'Nap', '-', 'Fell asleep in car', 'Transferred to cot but woke up after 1.5h'),
  ('2026-07-08', '20:00', '20:10', 'Bedtime', 'Pia', '(Post vomit) Bottle and short cuddle on armchair; transfer asleep', 'Initially accepted being put down into his cot immediately after stories and attempted to wind himself down with me next to him, but a bit of coughing triggered a vomit'),
  ('2026-07-09', '06:25', '06:50', 'Night wake-up', '-', 'Played and self settled', null),
  ('2026-07-09', '12:45', '12:55', 'Nap', 'Rosie', 'Cuddled till drowsy(ish) and then patted till sleep.', 'Initial try unsuccessful, but worked after 1 min more cuddles. He wanted to be put in the cot. Was acting not tired the whole time I was holding him'),
  ('2026-07-09', '19:25', '19:40', 'Bedtime', 'Dave', 'Rocked to sleep as too light in room to settle himself', null),
  ('2026-07-10', '12:25', '12:40', 'Nap', 'Rosie', 'Rocked to very drowsy, took a bit longer to settle due to light. Patted until fully asleep for about 3/4 mins', null),
  ('2026-07-10', '19:25', '19:40', 'Bedtime', 'Dave', 'Rocked to sleep as too light in room to settle himself', null),
  ('2026-07-11', '13:00', '13:05', 'Nap', 'Rosie', 'Rocked until slightly drowsy, patted in cot couple minutes', null),
  ('2026-07-11', '20:05', '20:45', 'Bedtime', 'Rosie', 'Up and down in cot, very resistant. Eventually put down almost asleep and then patted', null),
  ('2026-07-12', '12:30', '12:55', 'Nap', 'Rosie', 'Initially very upset, had to come downstairs and reset. Once back in room, rocked until just asleep then patted. Had to really encourage the sleep', null),
  ('2026-07-12', '19:25', '19:40', 'Bedtime', 'Dave', 'Rock to sleep; transfer deeply asleep', null),
  ('2026-07-13', '12:25', '12:30', 'Nap', 'Rosie', 'Walked around with him until literally just asleep, transferred immediately and patted while he waa waaed until asleep', null),
  ('2026-07-13', '19:25', '19:45', 'Bedtime', 'Dave', 'Rock to sleep; transfer deeply asleep. Quite tricky - he was very vocal the whole time.', null),
  ('2026-07-13', '21:10', '21:30', 'Night wake-up', 'Pia', 'Milk, snuggle, a couple of transfer attempts;', 'Initially refused milk but then had it; seemed unsettled; perhaps a belly ache as he had a troubled gut during the day?');
