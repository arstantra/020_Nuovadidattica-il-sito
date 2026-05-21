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
| Librerie JS | Nessuna dipendenza esterna; Chart.js solo in `docente-team.html` |
| Backend | Supabase (usato in `admin-feed.html` per feed e contenuti) |

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

| File | Dimensione | Descrizione |
|---|---|---|
| `index.html` | ~249 KB | Homepage principale |
| `capire-ai.html` | ~182 KB | Guida fondamentale "Capire l'AI" — 9 sezioni dal cos'è l'AI alle allucinazioni, privacy e domanda filosofica |
| `docente-team.html` | ~163 KB | Articolo blog "Il Docente-Team: Dirigere l'Ecosistema AI" |
| `admin-feed.html` | ~63 KB | Pannello admin per gestione feed (Supabase) |
| `notebooklm-generator.html` | ~44 KB | Tool generatore di prompt per NotebookLM |
| `CNAME` | — | `nuovadidattica.eu` |
| `README.md` | — | Placeholder minimo |

---

## Struttura della homepage (index.html)

Sezioni in ordine, con anchor ID:

1. **`#hero`** — Hero principale, sfondo scuro, headline animata
2. **`#motto`** — Citazione fondante con glifo grafico
3. **`#filosofia`** — Filosofia del metodo (bento grid con video, card espandibili, statistiche)
4. **`#casi`** — Applicazioni pratiche in classe
5. **`#etica`** — Sezione etica (sfondo scuro, accento giallo EU)
6. **`#toolbox`** — Strumenti consigliati
7. **`#feed`** — Feed di aggiornamenti (accento blu EU, dati da Supabase)
8. **`#blog`** — Articoli blog
9. **`#pubblicazioni`** — Pubblicazioni e risorse
10. **`#community`** — CTA iscrizione community

Navigazione: voce "Capire l'AI" (link a `capire-ai.html`) + link a tutte le sezioni + CTA "Unisciti" → `#community`.

Nella sezione `#filosofia`, prima del bento grid, è presente un hook `.capire-ai-hook` (sfondo scuro, testo + CTA gialla) che rimanda a `capire-ai.html` per i docenti alle prime armi.

---

## Pattern di design ricorrenti

**Custom cursor:** dot rosso 12px + ring 36px, `mix-blend-mode: difference`, segue mouse via JS.

**Reveal on scroll:** classe `.reveal` + `.reveal-delay-1/2/3` attivata da `IntersectionObserver`.

**Bento grid:** layout a griglia asimmetrica con card di dimensioni variabili (`.bento`, `.bento-card`).

**Section anatomy:**
```html
<section id="[id]">
  <div class="section-label reveal">Etichetta sezione</div>
  <h2 class="section-title reveal reveal-delay-1">Titolo</h2>
  <p class="section-subtitle reveal reveal-delay-2">Sottotitolo</p>
  <!-- contenuto -->
</section>
```

**Expand inline (Pattern B):** card cliccabili che espandono un pannello `.bento-expand` con JS `toggleExpand(id)`.

**Sezioni scure** (hero, etica): `background: var(--dark)`, testo `var(--text-light)`, label in `var(--eu-yellow)`.

**Sezioni chiare** (default): `background: var(--light)`, testo `var(--text-dark)`.

**Pagine guida** (pattern da `capire-ai.html`): nav con pulsante "← Home" + tag pagina al posto dei link sezione; griglia capitoli `.chapters-grid` 3×3 su `var(--dark-2)` al posto della barra TOC; footer identico alla homepage (logo ND + logo AP + credits).

---

## Navigazione e UI

- **Nav desktop:** logo + link sezioni + CTA pill rossa "Unisciti"
- **Nav mobile:** hamburger → menu overlay a schermo intero
- **Nav scrolled:** `background: rgba(10,10,10,0.85)` + `backdrop-filter: blur(16px)` dopo scroll
- **Logo:** base64 PNG iniettato via JS con costanti `ND_B64` e `AP_B64` definite nello script inline. Gli `<img>` hanno `src=""` nel markup e vengono popolati a runtime. IDs usati: `navLogoND`, `heroLogoND`, `footerLogoND`, `footerLogoAP`. Le costanti base64 reali sono in `index.html` (righe ~2232-2233) — copiare da lì per nuove pagine.

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
7. **Supabase** usato solo in `admin-feed.html`: URL e chiave configurabili da UI (mai hardcoded)

---

## Sezioni da sviluppare / TODO

> Aggiornare questa sezione ad ogni chat di lavoro

- [x] Pagina "Capire l'AI" (`capire-ai.html`) — creata, 9 sezioni, collegata dal nav e da hook in #filosofia
- [ ] Video sezione #filosofia (link YouTube da inserire)
- [ ] Completare sezione #feed con integrazione Supabase nella homepage
- [ ] Nuove pagine blog da aggiungere (struttura simile a `docente-team.html`)
- [ ] Sezione #pubblicazioni con lista reale pubblicazioni
- [ ] Pagina dedicata ADA (ada.nuovadidattica.eu)
- [ ] Form iscrizione community #community funzionante

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

---

*Ultima revisione: 2026-05-21 — aggiornare ad ogni sessione di lavoro significativa*
