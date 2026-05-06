# Lecture 1 - Introduction to Natural Language Processing

## What is NLP?
Natural Language Processing (NLP) is the subfield of artificial intelligence concerned with enabling computers to read, understand, generate, and respond to human language. Unlike formal languages (Python, SQL), human language is ambiguous, context-dependent, and constantly evolving - which is what makes NLP both interesting and hard.

NLP sits at the intersection of linguistics, computer science, and statistics. Modern NLP is dominated by neural methods, but classical statistical and rule-based approaches remain useful for low-resource settings and interpretability.

## Why is NLP hard?
Three sources of difficulty:
1. **Ambiguity** - "I saw the man with the telescope" has at least two parses.
2. **Variability** - the same idea can be expressed in dozens of ways: "buy", "purchase", "acquire", "pick up".
3. **Context dependence** - "bank" means a financial institution or a riverside, depending on context.

## Two pipelines
**Classical NLP pipeline:**
text → tokenisation → POS tagging → parsing → semantic analysis → application

**Modern neural pipeline:**
text → tokenisation (often subword: BPE, WordPiece, SentencePiece) → embedding → transformer encoder/decoder → output

Neural pipelines collapse many classical steps into learned representations, but tokenisation remains a critical pre-processing step in both.

## Common tasks
- **Text classification** - spam detection, sentiment analysis, topic labelling
- **Named entity recognition (NER)** - finding people, places, organisations
- **Machine translation** - English ↔ Polish, etc.
- **Summarisation** - extractive (select sentences) vs abstractive (generate new sentences)
- **Question answering** - extractive (span from passage) vs generative (free-form)
- **Dialogue / chat** - open-domain conversation

## Evaluation metrics
- **Accuracy** - fraction correct. OK for balanced classification.
- **Precision / Recall / F1** - for classification with class imbalance. F1 = 2·P·R/(P+R).
- **BLEU** - n-gram overlap with references. Standard for machine translation.
- **ROUGE** - n-gram overlap, recall-oriented. Standard for summarisation.
- **Perplexity** - for language models; lower = better. PPL = 2^(cross-entropy).

## A note on data
NLP is data-hungry. Modern transformer LMs are trained on hundreds of billions of tokens. For low-resource tasks, transfer learning from large pre-trained models (BERT, GPT, T5) is the standard recipe.
