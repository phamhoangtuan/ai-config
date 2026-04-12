# Development Workflow

> gstack is the primary workflow framework. All development follows the gstack lifecycle:
> Research → Plan → Build (TDD) → Review → Ship.

## gstack Development Lifecycle

### 0. Research & Reuse _(mandatory before any new implementation)_

Follow gstack's **Search Before Building** principle.

- **GitHub code search first:** Run `gh search repos` and `gh search code` to find existing implementations and patterns before writing anything new.
- **Library docs second:** Check primary vendor docs to confirm API behavior, package usage, and version-specific details.
- **Web research when needed:** Broader web research after GitHub search and primary docs are insufficient.
- **Check package registries:** Search npm, PyPI, crates.io, etc. before writing utility code. Prefer battle-tested libraries over hand-rolled solutions.
- **Search for adaptable implementations:** Look for open-source projects that solve 80%+ of the problem and can be forked, ported, or wrapped.

Use the `search-first` skill to enforce this workflow.

### 1. Plan

Choose the gstack planning skill that fits the task:

| Situation | gstack Skill |
|-----------|-------------|
| New product idea, brainstorming | `/office-hours` |
| Multi-session, multi-PR project | `/blueprint` |
| Scope & strategy review | `/plan-ceo-review` |
| Architecture, data flow, edge cases | `/plan-eng-review` |
| Design system, UI/UX review | `/plan-design-review` |
| Developer experience review | `/plan-devex-review` |
| Run all reviews automatically | `/autoplan` |

### 2. Build (TDD)

Use the `tdd-workflow` skill for test-driven development:

1. Write tests first (RED)
2. Implement to pass tests (GREEN)
3. Refactor (IMPROVE)
4. Verify 80%+ coverage

For debugging during implementation, use `/investigate` (systematic root-cause analysis). Do not fix bugs without first establishing the root cause.

### 3. Review

Use `/review` for pre-landing PR review. It checks SQL safety, LLM trust boundary violations, conditional side effects, and structural issues.

For security-specific review: `/cso` for a full audit, `security-review` skill for a commit-time checklist.

### 4. Ship

- `/ship` -- run tests, review diff, bump version, update changelog, commit, push, create PR
- `/land-and-deploy` -- merge PR, wait for CI, verify production health
- `/document-release` -- sync docs after shipping
