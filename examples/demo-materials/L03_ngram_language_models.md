# Lecture 3 — N-gram Language Models

## What is a language model?
A language model assigns a probability to a sequence of words: P(w₁, w₂, ..., wₙ). Equivalently, it predicts the next word given history: P(wₙ | w₁, ..., wₙ₋₁).

Language models are foundational: machine translation, speech recognition, autocomplete, spelling correction, and modern LLMs all rest on this single primitive.

## The Markov assumption
Conditioning on the entire history is intractable. The Markov assumption truncates context to the last (n-1) words:
- **Unigram (n=1):** P(wᵢ) — ignore context entirely
- **Bigram (n=2):** P(wᵢ | wᵢ₋₁) — depend on previous word only
- **Trigram (n=3):** P(wᵢ | wᵢ₋₁, wᵢ₋₂) — depend on previous two

Larger n captures more context but suffers from data sparsity (most n-grams never appear in training).

## Maximum Likelihood Estimation (MLE)
Estimate probability by counting:
P(wᵢ | wᵢ₋₁) = count(wᵢ₋₁, wᵢ) / count(wᵢ₋₁)

Example: in a corpus where "the cat" appears 30 times and "the" appears 1000 times,
P(cat | the) = 30 / 1000 = 0.03.

## The sparsity problem
MLE gives zero probability to any n-gram unseen in training. One zero in a sentence's product → entire sentence has probability 0. Catastrophic for held-out evaluation.

## Smoothing
Redistribute probability mass from observed events to unseen events.

**Add-1 (Laplace) smoothing:**
P(wᵢ | wᵢ₋₁) = (count(wᵢ₋₁, wᵢ) + 1) / (count(wᵢ₋₁) + V)
where V is vocabulary size. Simple, but over-smooths — gives unseen events too much mass.

**Add-k smoothing:** generalises add-1 with smaller k (e.g., 0.01). Tunable but still naive.

**Kneser-Ney smoothing:** state-of-the-art for n-gram LMs. Two ideas:
1. **Discounting** — subtract a constant d from observed counts
2. **Continuation probability** — back off to a lower-order model that uses *how many distinct contexts* a word appears in, not just its frequency. ("Francisco" appears often but only after "San"; it should not get high unigram probability.)

## Perplexity
Standard metric for language model quality on a held-out test set.

PPL(W) = P(w₁...wₙ)^(-1/n) = 2^(cross_entropy)

Lower is better. Intuition: perplexity is the weighted average branching factor — a model with PPL=100 is as confused as if it had to choose uniformly between 100 options at each step. Modern neural LMs achieve PPL of ~10-20 on standard benchmarks; n-gram models typically score 100-300.

## Why n-grams have been replaced
Neural language models (RNNs, transformers) learn distributed representations that:
1. Capture long-range dependencies
2. Generalise across morphologically related words
3. Don't suffer the same sparsity problem

But n-grams remain useful for:
- Low-resource languages
- On-device deployment with strict memory/latency budgets
- Interpretable baselines
- Spelling correction and autocomplete in constrained settings
