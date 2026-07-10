# CLAUDE.md — Contesto Globale Progetto NuovaDidattica.eu

> Questo file è il documento di riferimento per tutte le sessioni di lavoro sul sito.
> Aggiornarlo ogni volta che cambiano specifiche, nuove sezioni o decisioni architetturali.

---

## Identità del progetto

**Sito:** NuovaDidattica.eu
**Dominio live:** nuovadidattica.eu (CNAME GitHub Pages)
**Autore / owner:** Andrea Poletti (andrea.poletti@nuovadidattica.eu)
**Claim fondante:** *"Usare l'AI per fare i compiti è come avere i poteri dell'Uomo Ragno e usarli per fare l'antennista."*

**Missione:** Portare una visione critica e metodologica dell'AI nella didattica, su tre registri comunicativi distinti: adolescenti, studenti universitari, docenti/colleghi.

**Prodotto proprietario:** ADA — applicazione AI basata su API Gemini, disponibile su `ada.nuovadidattica.eu`.

---

## Stack tecnico

| Voce | Dettaglio |
|---|---|
| Tecnologie | HTML5 + CSS3 + JavaScript vanilla puro |
| Framework CSS | Nessuno — tutto CSS custom con variabili |
| Build process | Nessuno — file statici, deploy diretto |
| Deploy | GitHub Pages (branch `main`) |
| Font | Google Fonts: Syne (display), DM Sans (body), DM Mono (mono) |
| Librerie JS | Nessuna dipendenza esterna; Chart.js solo in `docente-team.html`; `@supabase/supabase-js@2` via CDN in `index.html` e `admin-feed.html` |
| Backend | Supabase — usato in `index.html` (feed, blog, pubblicazioni) e `admin-feed.html` (admin panel) |

**Regola principale:** ogni pagina è un singolo file HTML autosufficiente (CSS e JS inline). Non si creano file separati `.css` o `.js` salvo esplicita richiesta.

---

## Palette colori (CSS variables)

```css
:root {
  --red:       #D91B1B;   /* rosso principale, CTA, accenti */
  --red-deep:  #A51515;   /* rosso hover */
  --eu-blue:   #003FA5;   /* accento secondario (sezione feed) */
  --eu-yellow: #F5C800;   /* accento terziario (sezione etica, strategy) */
  --dark:      #0A0A0A;   /* sfondo hero e sezioni scure */
  --dark-2:    #141414;
  --dark-3:    #1E1E1E;
  --light:     #F5F3EE;   /* sfondo principale pagina */
  --light-2:   #ECEAE4;
  --light-3:   #E0DDD5;
  --text-dark: #0D0D0D;
  --text-mid:  #4A4A4A;
  --text-light:#F5F3EE;
  --text-muted:#8A8A8A;
  --radius:    20px;
  --radius-sm: 12px;
  --gap:       16px;
}
```

---

## Tipografia

```css
--font-display: 'Syne', sans-serif;    /* titoli, nav, label, CTA */
--font-body:    'DM Sans', sans-serif; /* testo corrente */
--font-mono:    'DM Mono', monospace;  /* codice, tag tecnici */
```

Pesi usati: Syne 400/600/700/800 · DM Sans 300/400/500 (anche italic) · DM Mono 400/500.

---

## File del progetto

| File | Descrizione |
|---|---|
| `index.html` | Homepage principale — feed, blog, pubblicazioni tutti da Supabase |
| `capire-ai.html` | Guida "Capire l'AI" — 9 sezioni, dropdown "Capitoli" nell'header + back-to-top "↑ Indice", collegata dal nav e dall'hook in #filosofia |
| `docente-team.html` | Articolo blog "Il Docente-Team: Dirigere l'Ecosistema AI" |
| `la-mente-rivendicata.html` | Paper "La Mente Rivendicata" — collegato da card in #filosofia |
| `guida-notebooklm.html` | Guida NotebookLM — collegata dalla card `tool-notebooklm` |
| `notebooklm-generator.html` | Tool generatore di prompt per NotebookLM (topbar con logo + menu unificato) |
| `prompt-coach.html` | Tool PromptCoach — analisi prompt via API Claude (key inserita dall'utente) |
| `verificai.html` | Tool VerificAI — progettazione verifiche in 4 step (contesto → obiettivo Bloom → forma → consegna+rubrica); topbar con logo + menu unificato. Nel toolbox la card si chiama "Verifiche a prova di AI" |
| `generatore-test.html` | Tool Generatore Test & Rubriche — wizard in 4 step (contesto classe → test → differenziazione BES/DSA e file A/B → rubrica+griglia) che produce prompt pronti da incollare nell'AI; topbar con logo + menu unificato |
| `admin-feed.html` | Pannello admin unificato: feed, blog, pubblicazioni (con card linking). Login Supabase Auth obbligatorio (`#loginScreen`) |
| `nd-components.js` + `nd-components-demo.html` | Libreria componenti sperimentale — NON usata dalle pagine di produzione |
| `supabase-rls-fix.sql` | Script RLS da eseguire nel SQL Editor di Supabase — vedi sezione "Sicurezza" |
| `CNAME` | `nuovadidattica.eu` |

---

## Struttura della homepage (index.html)

Sezioni in ordine, con anchor ID:

1. **`#hero`** — Hero principale, sfondo scuro, headline animata
2. **`#motto`** — Citazione fondante con glifo grafico
3. **`#filosofia`** — Filosofia del metodo (bento grid con video, card espandibili, statistiche)
4. **`#casi`** — Applicazioni pratiche in classe
5. **`#etica`** — Sezione etica (sfondo scuro, accento giallo EU)
6. **`#toolbox`** — Strumenti consigliati
7. **`#progetti`** — Progetti & Esperienze: La Tavola dei Pensatori (→ simposio.nuovadidattica.eu) + La Scuola dei Professoracci (→ professoracci.nuovadidattica.eu)
8. **`#feed`** — Feed di aggiornamenti (accento blu EU, dati da Supabase)
9. **`#blog`** — Articoli blog
10. **`#pubblicazioni`** — Pubblicazioni e risorse
11. **`#community`** — CTA iscrizione community

Navigazione: voce "Capire l'AI" (link a `capire-ai.html`) + link a tutte le sezioni + CTA "Unisciti" → `#community`.

Nella sezione `#filosofia`, prima del bento grid, è presente un hook `.capire-ai-hook` (sfondo scuro, testo + CTA gialla) che rimanda a `capire-ai.html` per i docenti alle prime armi.

---

## Pattern di design ricorrenti

**Custom cursor:** dot rosso 12px + ring 36px, `mix-blend-mode: difference`, segue mouse via JS.

**Reveal on scroll:** classe `.reveal` + `.reveal-delay-1/2/3` attivata da `IntersectionObserver`.

**Bento grid:** layout a griglia asimmetrica con card di dimensioni variabili (`.bento`, `.bento-card`). Vedi la sezione "Schema bento grid — regole vincolanti" più sotto.

**Section anatomy:**
```html
<section id="[id]">
  <div class="section-label reveal">Etichetta sezione</div>
  <h2 class="section-title reveal reveal-delay-1">Titolo</h2>
  <p class="section-subtitle reveal reveal-delay-2">Sottotitolo</p>
  <!-- contenuto -->
</section>
```

**Expand inline (Pattern B):** card cliccabili che espandono un pannello `.bento-expand` con JS `toggleExpand(id)`. Le card con expand hanno attributi `data-card-id` e `data-expand-id` per il sistema risorse.

**Expand raggruppati (wrapper):** se una sezione ha più pannelli expand, vanno racchiusi in un unico wrapper `span 12` con `display:none` di default (es. `#eticaCritExpands`, `#casiExpands`), altrimenti ogni pannello chiuso genera una gap-row vuota nella grid. I wrapper sono registrati nell'oggetto `expandWrappers` dentro `toggleExpand()` in `index.html` — nuovi wrapper vanno aggiunti lì.

**Card multi-CTA (Pattern D):** la card `.card-approfondimento` (docente-team) è un `<div>` con `onclick="window.location.href=..."` e un wrapper `.card-approfondimento-ctas` che contiene più link `<a>` in colonna — articolo + PDF quando disponibile. Non usare `<a>` come wrapper se servono più CTA.

**Sezioni scure** (hero, etica): `background: var(--dark)`, testo `var(--text-light)`, label in `var(--eu-yellow)`.

**Sezioni chiare** (default): `background: var(--light)`, testo `var(--text-dark)`.

**Pagine guida** (pattern da `capire-ai.html`): header unificato (vedi sezione non negoziabile) + dropdown "Capitoli ▾" nell'header (`.nav-chapters`) + pulsante fisso "↑ Indice" (`.back-to-top`) che compare superata la griglia capitoli; griglia capitoli `.chapters-grid` 3×3 su `var(--dark-2)` al posto della barra TOC; footer identico alla homepage (logo ND + logo AP + credits).

**Pagine tool** (pattern da `notebooklm-generator.html` / `verificai.html`): topbar sticky scura con **logo ND base64** (`.topbar-logo` + `#navLogoND`) + separatore + nome tool a sinistra, menu sito + hamburger a destra. Il vecchio wordmark testuale "N**D**" e il link "← NuovaDidattica.eu" sono stati eliminati (lug 2026): OGNI pagina monta il logo vero e il menu unificato.

---

## ⛔ Schema bento grid — regole NON NEGOZIABILI

> Ogni aggiunta, rimozione o modifica di card DEVE rispettare questo schema **su tutti e tre i formati (desktop, tablet, smartphone), senza che l'utente debba richiederlo**. **Mai lasciare spazi vuoti a fianco di una card.** Chi modifica una sezione è responsabile di ricomporla e verificarla nei tre formati.

### Regola fondamentale

Le grid desktop sono a **12 colonne** (`grid-template-columns: repeat(12, 1fr)`). **Ogni riga visiva deve sommare esattamente 12.** Righe ammesse:

| Composizione | Uso |
|---|---|
| `12` | Card hero / full-width (es. nlm-generator, tool-ada, banda etica) |
| `6+6` | Coppia paritaria (es. PromptCoach + VerificAI) |
| `7+5` | Coppia asimmetrica (es. video + card-filosofia) |
| `8+4` | Coppia asimmetrica forte (es. etica-main + etica-side) |
| `4+4+4` | Terzina regolare (es. classroom + notebooklm + drive) |
| `4+5+3` | Terzina espressiva — max una per sezione (es. riga 1 di #casi) |

**Parità:** con numero **pari** di card → coppie; con numero **dispari** → una card a riga intera (span 12) + coppie/terzine. Se aggiungi o togli una card, ricomponi le righe finché ogni riga somma 12 — non lasciare mai una card orfana con spazio vuoto accanto.

### Layout attuale per sezione (desktop)

| Sezione | Righe |
|---|---|
| `#filosofia` | `7+5` / `4+4+4` / `12` (docente-team) / `7+5` (mente-rivendicata + claim) |
| `#casi` | `4+5+3` / `6+6` (tutoring + studenti) |
| `#etica` | `8+4` / `4+4+4` / `12` (banda falso allarme) |
| `#toolbox` | `12` (nlm-gen) / `4+4+4` (classroom + notebooklm + drive) / `4+4+4` (PromptCoach + Verifiche a prova di AI + Generatore Test & Rubriche) / `12` (ADA) |

### Breakpoint

- **Tablet (601–900px):** grid a 2 colonne. Card dispari → l'ultima prende `span 2 !important` (mai orfana). Es.: `.caso-studenti`, `.tool-ada`, `.tool-nlm-generator`.
- **Mobile (≤768px / ≤600px):** tutte le grid → 1 colonna, tutte le card → `span 1 !important`.
- I pannelli `.bento-expand` sono sempre `span 12` (desktop) / `span 2` (tablet) / `span 1` (mobile) e non contano come card nel calcolo delle righe.

### Procedura vincolante — AGGIUNGERE una card

1. Conta le card della sezione DOPO l'aggiunta e ricomponi le righe: ogni riga desktop deve sommare 12 (composizioni ammesse sopra). Se non entra, ridistribuisci le card esistenti — mai una card orfana.
2. Aggiungi la regola desktop (`grid-column: span N`).
3. **Tablet (601–900px):** assegna lo span sulla grid a 2 colonne; se il totale card è dispari, l'ultima prende `span 2 !important`.
4. **Mobile (≤768px/≤600px):** aggiungi la card alla lista `span 1 !important`.
5. Se la card è cliccabile: classe `interactive`, `data-card-id` (e `data-expand-id` se ha pannello expand; il pannello va nel wrapper expand della sezione e registrato in `expandWrappers`).
6. Aggiorna la tabella "Layout attuale per sezione" qui sopra e, se la card può ricevere PDF, la tabella "ID card disponibili".

### Procedura vincolante — RIMUOVERE una card

1. Elimina markup + TUTTE le regole CSS della card nei tre formati (desktop, tablet, mobile) — niente selettori morti.
2. Ricomponi le righe della sezione: desktop deve tornare a somme di 12; tablet deve tornare pari (o ultima card `span 2 !important`).
3. Se la card aveva expand: rimuovi il pannello, il wrapper se resta vuoto, e la voce in `expandWrappers`.
4. Se la card aveva `data-card-id`: verifica in Supabase che nessuna pubblicazione la usi come `card_id` (altrimenti il CTA PDF sparisce in silenzio) e aggiorna la tabella "ID card disponibili".
5. Aggiorna la tabella "Layout attuale per sezione".

### Procedura vincolante — AGGIUNGERE / RIMUOVERE una sezione della homepage

1. Rispetta la **section anatomy** standard (label + title + subtitle) e l'alternanza sezioni chiare/scure.
2. Aggiorna la navigazione in **tutti** i punti: `.nav-links` desktop di `index.html`, `.mobile-menu` di `index.html`, e i menu unificati di TUTTE le pagine interne (che puntano a `index.html#sezione`).
3. Se la sezione contiene una bento grid: applica lo schema righe=12 e i tre breakpoint fin dalla prima stesura.
4. Aggiorna in questo file: elenco "Struttura della homepage", tabella "Layout attuale per sezione", TODO.
5. Se rimuovi una sezione: elimina anche le voci di menu in tutte le pagine e verifica che nessun link interno (`#anchor` o `index.html#anchor`) resti morto.

---

## ⛔ REGOLE UI/UX NON NEGOZIABILI — valgono per OGNI pagina, presente e futura

> Queste regole sono **vincolanti**. Nessuna pagina nuova può essere creata, e nessuna pagina esistente può essere modificata, in violazione di questi punti. Se una richiesta dell'utente sembra in conflitto, segnalarlo PRIMA di procedere. Non ripartire mai da zero: copiare i blocchi standard dalle pagine esistenti.

### 1. Header di orientamento su OGNI pagina (nessuna eccezione)

Ogni pagina pubblica DEVE avere un header fisso/sticky che contiene, nell'ordine:

1. **Logo ND cliccabile → `index.html`** — `<img src="" id="navLogoND" alt="NuovaDidattica.eu">` popolato a runtime dalla costante `ND_B64` (base64 PNG). La costante reale è in `index.html`: copiarla da lì (o da una qualsiasi pagina già a norma). MAI wordmark testuali al posto del logo.
2. **Menu sito desktop** `.nav-links` con le voci standard: Home, Capire l'AI, Filosofia, Applicazioni, Etica, Toolbox, Blog, Pubblicazioni, Community (link `index.html#sezione` dalle pagine interne, `#sezione` dalla homepage).
3. **Identità pagina** (facoltativa): `.nav-tag` / `.nav-badge` / nome tool — nascosta sotto i 1380px per non affollare.
4. **Hamburger** `.hamburger` (3 span) visibile **≤900px**, che apre l'overlay `.mobile-menu`.

Varianti ammesse (solo grafiche, mai strutturali):
- **Pagine editoriali** (articoli, guide, paper): nav fissa trasparente → `.scrolled` scura dopo scroll.
- **Pagine tool**: `.tool-topbar` sticky sempre scura.
- **`capire-ai.html`**: in più il dropdown "Capitoli ▾" — non sostituisce il menu sito, lo affianca.

### 2. Menu mobile standard (hamburger) su OGNI pagina

- Overlay `.mobile-menu` a schermo intero, sfondo `var(--dark)`, voci: Home, Capire l'AI, Filosofia, Applicazioni, Etica, Toolbox, Progetti, Feed, Blog, Pubblicazioni + CTA "Unisciti".
- JS standard: `toggleMenu()` (toggle classi `.open` + `body.style.overflow='hidden'`) + chiusura con Escape. Copiare il blocco `// MENU MOBILE (standard sito — vedi CLAUDE.md)` da una pagina esistente.
- L'hamburger è un `<button>` con `aria-label="Menu"`.

### 3. Zero overflow orizzontale (la "mezza pagina bianca")

- **OGNI pagina** deve avere `overflow-x:hidden` **sia su `html` sia su `body`** (iOS ignora la regola se è solo su `body`).
- Vietati elementi più larghi del viewport: attenzione a `100vw`, margini negativi, elementi decorativi assoluti senza `overflow:hidden` sul contenitore, tabelle non wrappate (usare `.table-scroll{overflow-x:auto}` sul wrapper, mai lasciare la pagina intera scrollabile).
- **Test obbligatorio prima di consegnare**: verificare a 360px, 390px, 768px che non esista scroll orizzontale.

### 4. Checklist nuova pagina (da eseguire SEMPRE, in ordine)

1. Copiare da una pagina a norma (`docente-team.html` per editoriali, `verificai.html` per tool): blocco CSS `/* ===== MENU SITO UNIFICATO ===== */`, markup nav + `.mobile-menu`, JS `toggleMenu`, costante `ND_B64`.
2. `html` e `body` con `overflow-x:hidden`.
3. Meta viewport presente.
4. Footer standard (logo ND + logo AP + credits) per le pagine editoriali.
5. Verificare i tre formati: desktop (≥1281px), tablet (901–1280px: gap ridotti, tag nascosto), mobile (≤900px: hamburger).

### Riferimenti tecnici

- **Nav scrolled:** `background: rgba(10,10,10,0.85)` + `backdrop-filter: blur(16px)` dopo scroll
- **Logo:** base64 PNG iniettato via JS con costanti `ND_B64` e `AP_B64` definite nello script inline. Gli `<img>` hanno `src=""` nel markup e vengono popolati a runtime. IDs usati: `navLogoND`, `heroLogoND`, `footerLogoND`, `footerLogoAP`. Le costanti base64 reali sono in `index.html` — copiare da lì per nuove pagine.
- **Breakpoint menu:** `.nav-links` visibile >900px; hamburger ≤900px; tag/badge nascosti ≤1380px.

---

## Tono e linguaggio

- **Lingua:** italiano sempre, nessun testo in inglese salvo termini tecnici consolidati (AI, prompt, feed)
- **Registro docenti:** autorevole ma accessibile, metodologico, non tecnocratico
- **Registro studenti/adolescenti:** diretto, concreto, con esempi pop-culture (es. Uomo Ragno)
- **Parole chiave:** metodo, ecosistema AI, dirigere (non usare), potenziare (non automatizzare), consapevolezza critica

---

## Regole di sviluppo

1. **Mai introdurre dipendenze esterne** non già presenti (no jQuery, no Bootstrap, no Tailwind)
2. **Ogni pagina resta un file unico** — CSS e JS inline nello stesso file HTML
3. **Commit in italiano** (seguire lo stile dei commit esistenti nel log git)
4. **Mobile-first responsive:** breakpoint principale a 768px con `@media (max-width: 768px)`
5. **Performance:** immagini inline base64 o SVG dove possibile; nessun fetch di asset pesanti
6. **Accessibilità:** `alt` su tutte le immagini, `aria-label` sui bottoni icon-only
7. **Supabase** — client `SB` condiviso in `index.html` (costanti `SB_URL`/`SB_KEY` hardcoded nello script); in `admin-feed.html` le stesse credenziali sono configurabili da UI con fallback su `localStorage`. Mai hardcodare in pagine pubbliche nuove senza valutare le RLS policy.
8. **onclick con dati complessi** — non usare `JSON.stringify(obj)` dentro attributi `onclick="..."`: le virgolette doppie spezzano l'HTML. Usare una cache JS indicizzata per ID (es. `_pubsCache`) e passare solo l'ID stringa.
9. **RLS obbligatoria su ogni tabella nuova, fin dalla creazione** — vedi sezione "Sicurezza" qui sotto. Nessuna tabella Supabase va lasciata senza policy esplicite, nemmeno per test rapidi.

---

## Sicurezza

**La anon key è pubblica per design** — è embeddata nel sorgente di `index.html` e `admin-feed.html`, chiunque può leggerla. La sicurezza non sta nel nasconderla ma nelle **RLS policy** di ogni tabella.

Pattern standard del progetto (vedi `supabase-rls-fix.sql` per lo script completo):

- **Lettura pubblica** (`to anon`): solo righe "pubblicate" (`published = true` o `status = 'published'`). Tabelle mai lette dal sito pubblico (es. `monitored_sources`) non hanno nessuna policy `anon` — zero accesso, nemmeno in lettura.
- **Scrittura** (insert/update/delete, policy `for all`): riservata `to authenticated`, **con `using`/`with check` sull'email specifica** (`auth.jwt() ->> 'email' = 'andrea.poletti@nuovadidattica.eu'`) — "authenticated" da solo non basta: se il progetto Supabase permette signup pubblici, chiunque potrebbe creare un account e aggirare la restrizione.
- **Tabelle con insert pubblico** (es. `iscritti`, form community): policy `insert to anon with check (true)` separata dalla policy admin, mai unita alla lettura — altrimenti la lista email diventa leggibile da chiunque.

`admin-feed.html` richiede login (schermata `#loginScreen`, Supabase Auth email/password) prima di mostrare `#adminLayout`: senza questo, con la RLS attiva, ogni scrittura dell'admin verrebbe rifiutata dal database. L'utente admin si crea manualmente in Supabase Dashboard → Authentication → Users (non è automatizzabile da SQL). Consigliato disattivare anche "Allow new users to sign up" in Authentication → Settings.

---

## Supabase — tabelle esistenti

| Tabella | Descrizione | Note |
|---|---|---|
| `feed_items` | Contenuti del feed ragionato | campi: title, description, url, source, category, status, found_at, published_at |
| `blog_posts` | Articoli blog leggibili inline | campi: title, body (HTML), excerpt, category, author, drive_url, published, published_at |
| `pubblicazioni` | Scritti & Quaderni (PDF su Drive) | campi: title, tipo, numero, drive_url, pages, excerpt, published, published_at, **card_id** |
| `monitored_sources` | Fonti RSS/YouTube monitorate | campi: name, url, tipo, active |
| `iscritti` | Iscrizioni community (form `#community` in `index.html`) | campi: email (unique) — solo insert pubblico, lettura/gestione riservata ad admin autenticato |

**`card_id`** in `pubblicazioni`: collega un PDF a una specifica bento card della homepage. Se valorizzato, `injectCardRisorse()` inietta automaticamente il CTA "Scarica PDF" nella card corrispondente. Se `null`, il PDF appare solo in Scritti & Quaderni.

---

## Sistema risorse — bento card linking

Le bento card della homepage che possono ricevere un PDF hanno:
- `data-card-id="[id]"` — identificatore unico della card
- `data-expand-id="[exp-id]"` — (solo card con expand) id del pannello `.bento-expand`

La funzione `injectCardRisorse()` in `index.html` gira dopo `loadPubblicazioni()` e inietta il CTA nella posizione giusta: dentro il pannello expand per le card con expand, in fondo alla card per le altre.

**ID card disponibili** (da usare nel campo `card_id` dell'admin):

| ID | Card |
|---|---|
| `card-filosofia-01` | Potenziare l'insegnamento, non automatizzarlo |
| `card-tre-cose` | 3 cose che puoi fare subito in classe |
| `card-stat-73` | 73% — Il problema della formazione |
| `card-claim-prompt` | Il prompt generico: il nemico invisibile |
| `card-docente-team` | Il Docente-Team (card con multi-CTA) |
| `caso-verifiche` | Verifiche & Valutazioni (→ `generatore-test.html`) |
| `caso-inclusione` | Inclusione BES/DSA (expand `exp-caso-incl`) |
| `caso-lezioni` | Unità Didattiche (expand `exp-caso-lez`) |
| `caso-tutoring` | Tutoring Personalizzato (expand `exp-caso-tut`) |
| `caso-studenti` | Studiare con l'AI senza barare (expand `exp-caso-stud`) |
| `tool-classroom` | Google Classroom |
| `tool-notebooklm` | NotebookLM |
| `tool-drive` | Google Drive |
| `tool-prompts` | PromptCoach |
| `tool-verificai` | Verifiche a prova di AI (VerificAI) — ospita il PDF "Riconoscere la AI" |
| `tool-testgen` | Generatore Test & Rubriche (→ `generatore-test.html`) |
| `tool-ada` | App ADA |

> `tool-pdf` e `caso-ada` sono stati rimossi (lug 2026): il primo sostituito da `tool-verificai`, il secondo dalla card `caso-studenti` (ADA resta presentata in `tool-ada`).

---

## Sezioni da sviluppare / TODO

> Aggiornare questa sezione ad ogni chat di lavoro

- [x] Pagina "Capire l'AI" (`capire-ai.html`) — creata, 9 sezioni, collegata dal nav e da hook in #filosofia
- [x] Sezione #feed con integrazione Supabase nella homepage — operativa
- [x] Sezione #pubblicazioni con lista reale pubblicazioni — operativa, PDF da Google Drive
- [x] Sistema card linking (pubblicazioni.card_id → bento card CTA) — operativo
- [x] Admin panel unificato (feed + blog + pubblicazioni) in `admin-feed.html`
- [x] VerificAI: card nel #toolbox + link da `caso-verifiche` + topbar sito su `verificai.html`
- [x] Card #casi ricablate: expand Pattern B con contenuto metodologico (niente più scroll generici)
- [x] Menu "Capitoli" + back-to-top su `capire-ai.html`
- [ ] Video sezione #filosofia (link YouTube da inserire)
- [ ] Nuove pagine blog da aggiungere (struttura simile a `docente-team.html`)
- [ ] Pagina dedicata ADA (ada.nuovadidattica.eu)
- [x] Form iscrizione community #community funzionante — insert su `iscritti` operativo (mancano ancora eventuali notifiche/gestione admin degli iscritti)
- [ ] Creare utente admin in Supabase Auth ed eseguire `supabase-rls-fix.sql` (vedi sezione Sicurezza) — passaggio manuale ancora da fare

---

## Decisioni architetturali prese

| Data | Decisione | Motivazione |
|---|---|---|
| apr 2025 | Architettura single-file HTML | Semplicità deploy GitHub Pages, nessun build step |
| apr 2025 | Nessun framework CSS | Controllo totale sul design, performance |
| mag 2025 | ADA su sottodominio separato | Separazione tool applicativo dal sito editoriale |
| mag 2025 | Supabase per contenuti feed | Backend gestito senza server proprietario |
| mag 2026 | Pagina "Capire l'AI" come sezione separata dal nav | Non appesantire homepage; chi sa già salta la pagina, chi no ha una risorsa dedicata |
| mag 2026 | Griglia capitoli 3×3 invece di barra TOC orizzontale | La barra scroll era poco elegante; la griglia è visivamente intenzionale e coerente col design |
| mag 2026 | PDF ospitati su Google Drive (non nella repo) | Evita appesantire la repo GitHub; Drive gestisce versioning e accesso |
| mag 2026 | `pubblicazioni.card_id` per collegare PDF alle bento card | Un campo solo fa due cose: appare in Scritti & Quaderni E inietta CTA nella card — zero duplicazioni |
| mag 2026 | Admin unificato in `admin-feed.html` per feed + blog + pubblicazioni | Un solo pannello editoriale; nessun file da toccare per aggiungere contenuti |
| mag 2026 | Cache `_pubsCache` in admin invece di JSON.stringify in onclick | Le virgolette doppie nel JSON spezzano gli attributi HTML — pattern da seguire per tutti i render futuri |
| lug 2026 | Card #casi con expand inline invece di scroll verso feed/blog/pubblicazioni | Le destinazioni generiche deludevano la promessa delle card; il contenuto metodologico vive nella card stessa |
| lug 2026 | ADA presentata solo in #toolbox (`tool-ada`); rimossa la card duplicata in #casi | Una sola presentazione completa vale più di due parziali; in #casi al suo posto la card studenti |
| lug 2026 | Card `tool-pdf` eliminata, sostituita da `tool-verificai` | Duplicava tool-drive e #pubblicazioni; VerificAI è contenuto reale al posto di un placeholder |
| lug 2026 | Schema bento grid formalizzato (righe che sommano 12, regola pari/dispari) | Coerenza grafica vincolante per ogni futura aggiunta/rimozione di card |
| lug 2026 | Dropdown "Capitoli" + back-to-top sulle pagine guida | Con ~15 min di lettura serve orientamento costante, non solo l'indice in cima |
| lug 2026 | **Menu sito unificato su OGNI pagina** (logo ND base64 + `.nav-links` + hamburger + `.mobile-menu`) | Navigando tra le pagine ci si perdeva: header incoerenti, logo assente sui tool, nessun hamburger fuori da index. Regola blindata in "REGOLE UI/UX NON NEGOZIABILI" |
| lug 2026 | Revocata l'eccezione "pagine tool leggere senza logo base64" | La coerenza di navigazione vale più dei ~90KB del logo; ogni pagina monta il logo vero |
| lug 2026 | `overflow-x:hidden` obbligatorio su `html` E `body` in ogni pagina | Su mobile compariva una "mezza pagina bianca" scrollabile: iOS ignora la regola se applicata solo a `body` |
| lug 2026 | Procedure vincolanti add/remove card e sezioni (desktop+tablet+mobile) | Ogni modifica ricomponeva la grid a mano e a memoria; ora la procedura è scritta e non negoziabile |
| lug 2026 | Nuovo tool `generatore-test.html` (Generatore Test & Rubriche) + card `tool-testgen`; riga toolbox 6+6 → 4+4+4 | La card `caso-verifiche` prometteva "test, rubriche e griglie in pochi minuti" ma linkava VerificAI, che fa progettazione metodologica: due lavori diversi, due tool distinti |
| lug 2026 | Card toolbox rinominata "Verifiche a prova di AI" (il nome VerificAI resta nel testo) | "VerificAI" da solo non comunicava lo scopo: la card ora spiega che serve a progettare verifiche non delegabili all'AI dagli studenti |
| lug 2026 | PDF "Riconoscere la AI" spostato da `caso-verifiche` a `tool-verificai` (card_id in Supabase) | Il PDF parla di riconoscere elaborati fatti con l'AI: era fuori tema sulla card dei test, è coerente con le verifiche a prova di AI |
| lug 2026 | RLS abilitata su tutte le tabelle Supabase + login Supabase Auth obbligatorio su `admin-feed.html` (email/password, scritture ristrette a `andrea.poletti@nuovadidattica.eu`) | La anon key pubblica permetteva insert/update/delete senza restrizioni: chiunque leggesse il sorgente del sito poteva modificare feed, blog e pubblicazioni. Segnalato da Andrea il 2026-07-10. Vedi sezione "Sicurezza" e `supabase-rls-fix.sql` |

---

*Ultima revisione: 2026-07-10 (4ª sessione) — fix sicurezza: RLS su tutte le tabelle Supabase (incluso `iscritti`, ora documentata) + login obbligatorio su `admin-feed.html`; SQL in `supabase-rls-fix.sql`; nuova sezione "Sicurezza"*
