# vaultcraft demo materials

Three synthetic NLP lecture stubs used by `./install.sh --demo` to let new users see what vaultcraft produces before pointing it at real coursework.

## Contents

- `L01_intro_to_nlp.md` — what NLP is, classic vs neural pipelines, evaluation metrics
- `L02_text_preprocessing.md` — tokenisation, stemming/lemmatisation, stopwords, normalisation
- `L03_ngram_language_models.md` — n-gram probability, smoothing (add-1, Kneser-Ney), perplexity

## How the demo runs

The agent treats this folder like any other source directory. From these three short markdown files it produces:

- One MOC (`00 — Start Here.md`) lecture-first
- Three lecture notes with worked examples and exam questions
- ~12–18 atomic concept notes (tokenisation, BPE, perplexity, MLE estimate, etc.) with hover-visible definitions
- A `Tables.md` comparing smoothing techniques
- A populated graph view with no orphan nodes

Total runtime on `lean` depth: typically 4–7 minutes.

## License

These materials are written from scratch for this repo. CC0 — use freely.
