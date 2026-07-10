-- =====================================================================
-- NuovaDidattica.eu — Fix sicurezza: RLS + scritture limitate agli
-- utenti autenticati
--
-- PROBLEMA: la anon key (pubblica per progetto, embeddata nel sorgente
-- di index.html e admin-feed.html) permetteva insert/update/delete
-- senza restrizioni su tutte le tabelle. Chiunque leggesse il sorgente
-- del sito poteva modificare feed, blog e pubblicazioni.
--
-- Da eseguire in: Supabase Dashboard → SQL Editor → New query
-- Eseguire tutto lo script in un colpo solo, dall'alto in basso.
-- =====================================================================


-- ─── STEP 0 — Controllo preliminare ──────────────────────────────────
-- Mostra le policy già esistenti sulle tabelle del progetto. Se ne vedi
-- di permissive (roles = {public} o {anon} su insert/update/delete,
-- oppure "using (true)" senza condizioni), la tabella qui sotto le
-- sostituisce — ma le vecchie policy NON vengono rimosse in automatico
-- se hanno un nome diverso da quelle create da questo script (le policy
-- si sommano in OR: basta che UNA sia permissiva perché la scrittura
-- passi comunque). Esegui questa query per prima e controlla il risultato:

select schemaname, tablename, policyname, cmd, roles, qual, with_check
from pg_policies
where schemaname = 'public'
order by tablename, cmd;

-- Se trovi policy vecchie non elencate in questo script, droppale con:
--   drop policy "nome_esatto_della_policy" on public.nome_tabella;
-- prima di procedere con gli step successivi.


-- ─── STEP 1 — feed_items ──────────────────────────────────────────────
-- Pubblico: solo lettura degli item con status = 'published'.
-- Admin autenticato: lettura/scrittura completa (serve anche per la
-- coda di approvazione, che ha status = 'pending').

alter table public.feed_items enable row level security;

drop policy if exists "feed_items_public_select" on public.feed_items;
create policy "feed_items_public_select"
  on public.feed_items for select
  to anon
  using (status = 'published');

drop policy if exists "feed_items_admin_all" on public.feed_items;
create policy "feed_items_admin_all"
  on public.feed_items for all
  to authenticated
  using (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu')
  with check (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu');


-- ─── STEP 2 — blog_posts ──────────────────────────────────────────────

alter table public.blog_posts enable row level security;

drop policy if exists "blog_posts_public_select" on public.blog_posts;
create policy "blog_posts_public_select"
  on public.blog_posts for select
  to anon
  using (published = true);

drop policy if exists "blog_posts_admin_all" on public.blog_posts;
create policy "blog_posts_admin_all"
  on public.blog_posts for all
  to authenticated
  using (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu')
  with check (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu');


-- ─── STEP 3 — pubblicazioni ────────────────────────────────────────────

alter table public.pubblicazioni enable row level security;

drop policy if exists "pubblicazioni_public_select" on public.pubblicazioni;
create policy "pubblicazioni_public_select"
  on public.pubblicazioni for select
  to anon
  using (published = true);

drop policy if exists "pubblicazioni_admin_all" on public.pubblicazioni;
create policy "pubblicazioni_admin_all"
  on public.pubblicazioni for all
  to authenticated
  using (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu')
  with check (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu');


-- ─── STEP 4 — monitored_sources ────────────────────────────────────────
-- Non viene mai letta dal sito pubblico (solo da admin-feed.html):
-- zero accesso anonimo, né in lettura né in scrittura.

alter table public.monitored_sources enable row level security;

drop policy if exists "monitored_sources_admin_all" on public.monitored_sources;
create policy "monitored_sources_admin_all"
  on public.monitored_sources for all
  to authenticated
  using (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu')
  with check (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu');


-- ─── STEP 5 — iscritti ──────────────────────────────────────────────────
-- Tabella non ancora documentata in CLAUDE.md — usata dal form iscrizione
-- community in index.html (SB.from('iscritti').insert({ email })).
-- Pubblico: solo insert (chiunque può iscriversi). Nessuno può leggere,
-- modificare o cancellare la lista tranne l'admin — altrimenti chiunque
-- potrebbe leggere via API tutte le email iscritte.

alter table public.iscritti enable row level security;

drop policy if exists "iscritti_public_insert" on public.iscritti;
create policy "iscritti_public_insert"
  on public.iscritti for insert
  to anon
  with check (true);

drop policy if exists "iscritti_admin_all" on public.iscritti;
create policy "iscritti_admin_all"
  on public.iscritti for all
  to authenticated
  using (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu')
  with check (auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu');


-- =====================================================================
-- DOPO aver eseguito questo script, due passaggi manuali obbligatori
-- nella Dashboard Supabase (non automatizzabili da SQL):
--
-- 1) Authentication → Users → Add user
--    Crea un utente con email andrea.poletti@nuovadidattica.eu e una
--    password a tua scelta. È l'account con cui accedi a admin-feed.html
--    (schermata di login aggiunta insieme a questo script).
--
-- 2) Authentication → Settings → "Allow new users to sign up" → OFF
--    Le policy sopra sono già ristrette alla tua sola email, ma
--    disattivare le registrazioni pubbliche è una protezione in più:
--    senza, chiunque potrebbe comunque creare un account autenticato
--    (che però non potrebbe scrivere nulla, grazie al check sull'email).
--
-- Verifica finale: apri index.html — feed/blog/pubblicazioni devono
-- caricare come prima. Apri admin-feed.html — deve chiedere login;
-- prova a scrivere senza account valido (deve fallire), poi con le
-- credenziali create al punto 1 (deve funzionare).
-- =====================================================================
