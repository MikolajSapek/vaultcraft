# Contributing to vaultcraft

Thanks for considering a contribution! This project lives by students and learners sharing what works for their courses.

## Ways to contribute

| Type | Effort | What it looks like |
|---|---|---|
| **Bug report** | 5 min | Open an issue describing what the agent did wrong |
| **Course recipe** | 15 min | Share intake answers + sample output that worked well for your course type |
| **Improvement to the agent prompt** | 30 min | PR with a tested change to `agents/vaultcraft.md` |
| **New template** | 30 min | PR adding a template for a course type that's not covered (e.g., language courses, lab-heavy courses) |
| **Documentation improvement** | 10–60 min | PR fixing typos / clarifying instructions / adding examples |
| **GitHub Action / CI** | varies | PR adding linting, link-checking, or other automation |

## Before opening a PR

1. **Open an issue first** if it's a substantial change — saves rework if maintainers disagree on the approach.
2. **Run the agent on your own course** to test that your change works end-to-end. We can't merge an agent change that wasn't tested on real materials.
3. **Anonymise your examples** before committing. No real names, emails, course codes, professor names, file paths with usernames.

## Contribution workflow

```bash
# 1. Fork the repo on GitHub, then clone your fork
git clone https://github.com/YOUR_FORK/vaultcraft.git
cd vaultcraft

# 2. Branch
git checkout -b feature/short-description

# 3. Make changes
# ... edit files ...

# 4. Test
# Copy your modified agent into ~/.claude/agents/ and run it on real materials

# 5. Commit
git add .
git commit -m "Short, descriptive subject

Longer body explaining the why and any non-obvious choices."

# 6. Push and open PR
git push origin feature/short-description
```

## Style and conventions

### Agent file (`agents/vaultcraft.md`)

- Numbered principles must remain in their existing slots — adding a principle = appending at the end and bumping the count, not inserting and shifting.
- Cross-references like *"per Principle 18"* must be updated when you renumber.
- Phase ordering is load-bearing — don't reorder phases; add new phases as `Phase X.5` between existing ones if needed.
- Examples in the agent must use placeholder paths like `/Users/me/Downloads/` — never real usernames.

### Documentation (`docs/`)

- British English throughout.
- Cross-link generously between docs.
- Code samples use markdown fenced code blocks with language hints.
- Examples should be runnable / verifiable, not aspirational.

### Templates (`templates/`)

- Templates are skeletons, not examples. They have placeholder text in `<angle brackets>` or `UPPERCASE_PLACEHOLDERS`.
- Match the conventions in `docs/conventions.md` exactly — templates ARE the spec.

### Privacy in commits

- Never commit a real vault's content as an example.
- Never commit `.obsidian/workspace.json` or any plugin's session/settings data — see `.gitignore`.
- If you want to share an example note, write a synthetic one with no real course / institution / person references.

## Code of conduct

Be kind. Assume good faith. Help newcomers. We're all here to help each other study better.

See `CODE_OF_CONDUCT.md` for the full text.

## Questions?

Open a discussion on the GitHub Discussions tab, or open an issue with the `question` label.
