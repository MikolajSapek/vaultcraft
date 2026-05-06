# Examples

What notes look like after the agent has built them.

## Example concept note - `Kneser-Ney Smoothing`

```markdown
---
tags: [concept, course/nlp]
aliases: [Kneser-Ney, Modified Kneser-Ney]
source: "[[L03 - N-gram Language Models]]"
status: new
difficulty: 3
created: 2026-04-22
exam-likely: true
course: NLP
---

# Kneser-Ney Smoothing

> [!definition] Definition
> **Kneser-Ney smoothing** estimates n-gram probabilities using continuation
> probability - how many distinct contexts a word follows - rather than raw
> frequency, giving the best results among classical smoothing methods.

## Intuition

Suppose you're predicting what comes after the empty `"___"`. Regular
methods would guess "Francisco" if Francisco is frequent in the corpus. But
Francisco is ONLY frequent after "San" - it almost never starts new
sentences. Kneser-Ney is smarter: it asks *"How many DIFFERENT contexts has
this word appeared in?"* "of" appears after many different words; "Francisco"
appears after only one. So "of" is a better guess for a blank slot. KN
predicts based on versatility, not frequency.

## Worked numerical example

Suppose in our corpus:
- "Francisco" appears 500 times - but 495 are after "San"; only 5 distinct contexts
- "of" appears 500 times - appears after ~300 distinct contexts

Continuation probability $P_{CONT}(w)$ is proportional to the number of
unique contexts $w$ has appeared in:
- $P_{CONT}(\text{Francisco}) \propto 5$
- $P_{CONT}(\text{of}) \propto 300$

So Kneser-Ney estimates $P_{CONT}(\text{of})$ as ~60× higher than
$P_{CONT}(\text{Francisco})$, even though their raw counts are identical.

## Formula sketch

$$ P_{KN}(w_i \mid w_{i-1}) = \frac{\max(c(w_{i-1}, w_i) - d, 0)}{c(w_{i-1})} + \lambda(w_{i-1}) \cdot P_{CONT}(w_i) $$

where $d \approx 0.75$ is a discount and $\lambda$ normalises so
probabilities sum to 1.

## When to use vs avoid

- **Use when:** classical n-gram models needed (interpretability, low compute,
  speech recognition production systems)
- **Avoid when:** modern neural LMs are available - they always beat KN

## Relations

- Classical alternative: [[Laplace Smoothing]] (over-smooths)
- Stronger alternative: [[Add-k Smoothing]] (still flat)
- Hierarchy: [[Linear Interpolation]] mixes orders; KN is a smoothed unigram
- Used in: [[L03 - N-gram Language Models]]

## Simple explanation (ELI5)

> [!tip] Explain like I'm five
> Imagine predicting the next word after a blank `"___"`. Regular methods
> would guess "Francisco" if it's frequent. But "Francisco" almost ONLY
> appears after "San". Kneser-Ney asks: *"How many DIFFERENT contexts has
> this word appeared in?"* "Of" appears after many different words;
> "Francisco" appears after only one. So "of" is a better guess for a blank
> slot. KN predicts based on versatility, not frequency.

## Flashcards

Why is Kneser-Ney superior to add-k?::Uses continuation probability - words appearing in many distinct contexts get higher unigram weight, giving more realistic estimates for novel n-grams.
What's the discount value d typically?::~0.75 (Modified Kneser-Ney) or 0.5 (basic).

## Sources

- [[L03 - N-gram Language Models]]
- Jurafsky & Martin, Speech and Language Processing, Ch. 3
```

What this gives you in Obsidian:

- **Hover over `[[Kneser-Ney Smoothing]]`** in any other note → the definition callout pops up. No clicking required.
- **Cmd+O → "Kneser"** → jump to the note.
- **Graph view** → see this note connected to Laplace Smoothing, Add-k Smoothing, Linear Interpolation, L03.
- **Spaced Repetition plugin** → 2 flashcards from this note get scheduled for review.

---

## Example lecture note - `L03 - N-gram Language Models` (excerpt)

```markdown
---
tags: [lecture, course/nlp]
aliases: [L03, Lecture 03 NLP]
source: session-03-26.pdf
status: review
created: 2026-04-21
exam-likely: true
course: NLP
---

# L03 - N-gram Language Models

> [!tldr] TL;DR
> - A language model assigns $P(W)$ to any word sequence - useful for
>   generation, correction, ranking.
> - Chain rule + [[Markov Assumption]] → bigram/trigram MLE from corpus
>   counts.
> - Bigram MLE: $\hat{P}(w_i \mid w_{i-1}) = C(w_{i-1},w_i)/C(w_{i-1})$.
> - Zero-count problem: unseen n-gram → $P = 0$ → [[Perplexity]] = ∞.
> - Laplace adds 1; add-k generalizes; Kneser-Ney is the gold standard.

## Language Models

> [!definition] In one line
> A **[[N-gram Language Model]]** assigns probability $P(W)$ to any word
> sequence by decomposing it into conditional next-word probabilities
> estimated from corpus counts.

**Intuition.** A language model answers one fundamental question: how
likely is this sequence of words? That sounds simple, but it enables a huge
range of applications. Speech recognition outputs multiple hypothetical
transcriptions - *"recognise speech"* vs *"wreck a nice beach"* - and the
LM ranks them by probability. Spelling correctors choose *"Their dog"* over
*"There dog"* because *"Their dog"* has higher bigram probability. ...

[continues for ~2000 more words across topic sections...]

## Potential Exam Questions

### Theory / Definitions
1. **Define the Markov assumption in the context of language modelling.** -
   The probability of the next word depends only on the last $k$ preceding
   words. Makes computation tractable at the cost of ignoring long-range
   dependencies. See [[Markov Assumption]].
2. **What is the maximum likelihood estimate for a bigram probability?** -
   $\hat{P}(w_i \mid w_{i-1}) = C(w_{i-1}, w_i) / C(w_{i-1})$.

### Understanding / Comparison
3. **Compare Laplace, add-k, and Kneser-Ney smoothing.** - Laplace adds 1
   to every count (over-smooths). Add-k generalizes with tuneable k. KN
   uses continuation probability - far better. See [[N-gram Smoothing]].

### Application / Worked problem
4. **Compute the bigram MLE for "the cat" given the corpus...** - pointer.

### Critical thinking
5. **Why is KN superior to add-k? What concept does it exploit?** - KN uses
   continuation probability - a word's "context versatility" rather than
   raw frequency. See [[Kneser-Ney Smoothing]].

## Sources
- Slides: `session-03-26.pdf`
- Lab: [[Lab03 - N-gram Models & MLE]]
```

---

## Example `Tables.md` excerpt

```markdown
## 1. Classifiers - Naive Bayes vs Logistic Regression vs SVM vs Neural Networks

| Method | Type | Assumption | Training speed | Small data | Say this |
|---|---|---|---|---|---|
| [[Naive Bayes]] | Generative | Features independent given class | Very fast | Strong | "Fast baseline, works surprisingly well for text when you have little data." |
| [[Logistic Regression]] | Discriminative | Linear decision boundary | Fast | Decent | "Discriminative linear model, standard baseline for text classification with TF-IDF." |
| SVM | Discriminative | Margin maximization, kernel trick | Slow for large | Very strong | "Strong for high-dimensional text, slow to train - use when features are dense and data moderate." |
| [[Neural Network]] | Discriminative | Universal approximator | Slow | Overfits | "Deep models dominate when you have data and compute; no feature engineering needed." |

**Decision tree for "which classifier?":**
- < 10k labeled samples? → [[Naive Bayes]] or [[Logistic Regression]]
- High-dim sparse features? → [[Logistic Regression]] or SVM
- 100k+ samples + GPU? → [[Neural Network]] / [[Transformer]]
- Need interpretable feature weights? → [[Logistic Regression]]
```

The "Say this" column is the exam-night gold - read it aloud, and you have a confident opening sentence for any oral exam question.

---

## Example graph view setup

After the agent runs, your graph view will be colour-coded:

- **Orange** - Lectures
- **Blue** - Concepts
- **Yellow** - Labs
- **Purple** - Formulas (if used)
- **Green** - Examples (if used)

Tags are hidden. Unresolved links are hidden. The graph shows actual semantic structure.

For multi-course vaults, each course's folders get their own colour grouping - toggle between courses with the search filter (`path:NLP/`, `path:ML/`, etc.).

---

## What you don't get

The agent **does not**:
- Generate flashcard SRS schedules - that's the [Spaced Repetition plugin's](https://github.com/st3v3nmw/obsidian-spaced-repetition) job. The agent puts `::` flashcards in every note; the plugin schedules reviews.
- Answer exam questions - it generates them so you can practice.
- Make the vault for you forever. New lectures = new agent invocation (incremental mode).
- Replace doing the work. Reading and writing your own concepts still produces the deepest understanding. The vault is a scaffold, not a substitute.
