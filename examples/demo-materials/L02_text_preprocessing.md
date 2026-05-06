# Lecture 2 — Text Preprocessing

## Why preprocess?
Raw text is messy: mixed case, punctuation, unicode quirks, HTML tags, encoding issues. Preprocessing reduces this noise so downstream models can focus on signal.

A preprocessing pipeline is task-dependent: aggressive cleaning helps a bag-of-words classifier; modern transformers prefer minimal preprocessing because their tokenisers expect raw input.

## Tokenisation
Splitting a string into tokens (the basic units the model sees).

**Word-level tokenisation:**
- Split on whitespace and punctuation
- Problems: out-of-vocabulary words ("Czyżkówko" is unseen), morphological variants ("run", "running", "ran") are separate tokens
- Implementation: `nltk.word_tokenize`, `spacy`

**Subword tokenisation** (modern default):
- **BPE (Byte-Pair Encoding)** — greedy merge of most-frequent character pairs. Used by GPT-2, RoBERTa.
- **WordPiece** — similar to BPE but uses likelihood to choose merges. Used by BERT.
- **SentencePiece** — language-agnostic, treats text as a stream of unicode codepoints. Used by T5, ALBERT, mT5.

Subword units handle rare/unknown words ("Czyżkówko" → ["Cz", "yż", "kó", "wko"]), keeping vocabulary size manageable (~30K-50K tokens) while never producing UNK.

## Normalisation
Reducing surface-form variation:
- **Lowercasing** — collapses "Apple" / "APPLE" / "apple". Loses case-sensitive info (named entities).
- **Unicode normalisation** — NFC vs NFD; "café" can be one codepoint or "cafe + combining acute".
- **Punctuation handling** — strip, keep, or treat as tokens.

## Stemming vs Lemmatisation
Both map word variants to a common form:
- **Stemming** — chop off suffixes by rules. Fast, crude. "running" → "run", "happily" → "happi". Algorithm: Porter stemmer (1980).
- **Lemmatisation** — return the dictionary form using morphological analysis. Slower, accurate. "running" → "run", "better" → "good", "geese" → "goose". Requires POS context: "saw" (verb) → "see", "saw" (noun) → "saw".

Modern neural models rarely need either — embeddings learn that "run" and "running" are related.

## Stopword removal
Remove very-frequent low-information words ("the", "a", "is", "and"). Useful for bag-of-words classification, harmful for sequence models that need them for syntax.

## A typical pipeline (classical sentiment classifier)
```
raw text
  → lowercase
  → strip HTML
  → tokenize (word level)
  → remove stopwords
  → stem
  → bag-of-words / TF-IDF features
  → classifier
```

## A typical pipeline (modern transformer)
```
raw text
  → minimal cleanup (strip HTML)
  → subword tokenizer (BPE/WordPiece)
  → integer ids
  → transformer
```
