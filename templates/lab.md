---
tags: [lab, course/COURSE_SHORT_NAME]
lab: X
source-file: lab_XX_filename.ipynb
related-lecture: "[[L0X - Lecture Title]]"
course: COURSE_NAME
---

# Lab 0X - Lab Topic Title

> [!tldr] What this lab teaches
> - Skill 1 - one line
> - Skill 2 - one line
> - Skill 3 - one line

## Libraries & functions introduced

| Function / class | Purpose | Concept |
|---|---|---|
| `CountVectorizer(...)` | Turns text into BoW matrix | [[Bag of Words]] |
| `word_tokenize(text)` | NLTK tokenizer | [[Tokenization]] |
| `stemmer.stem(word)` | Porter stemmer | [[Stemming]] |

(List every non-trivial function the lab uses. Each gets a wikilink to the concept it implements.)

## Core code patterns

### Pattern 1 - What this pattern does

```python
import ...
X = CountVectorizer().fit_transform(corpus)
```

**What's happening:** 2–3 line explanation. Highlight the line that matters most.

**Gotcha:** 1 line about a common mistake or subtle behaviour.

### Pattern 2 - Next pattern

```python
# code
```

**What's happening:** ...

**Gotcha:** ...

(2–4 patterns per lab, the ones worth memorizing for exam.)

## Expected output

What you see when you run the lab end-to-end. If notebook has outputs, reference the most illuminating one.

## Connection to lecture

This lab exercises concepts from [[L0X - Lecture Title]]:
- [[Concept A]] - how it shows up in this lab
- [[Concept B]] - how
- [[Concept C]] - how

## Gotchas / common mistakes

- Common mistake 1 (with brief explanation)
- Common mistake 2

## Potential exam questions

1. **Coding-style or conceptual question this lab prepares you for** - pointer with [[wikilink]].
2. ...
3. ...

## Sources

- Notebook: `lab_XX_filename.ipynb`
- Related lecture: [[L0X - Lecture Title]]
