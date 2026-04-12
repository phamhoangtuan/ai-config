# Git Workflow

## Commit Message Format

```
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci

## Pull Request Workflow

Use `/ship` to handle the full PR creation flow:
- Runs tests and reviews diff
- Bumps VERSION and updates CHANGELOG
- Commits, pushes, and creates PR with full commit history context

Use `/review` for pre-landing review before merging.

When creating PRs manually:
1. Analyze full commit history (`git diff [base-branch]...HEAD`)
2. Draft comprehensive PR summary
3. Push with `-u` flag if new branch

> For the full development lifecycle (research, planning, TDD, review) before git
> operations, see [development-workflow.md](./development-workflow.md).
