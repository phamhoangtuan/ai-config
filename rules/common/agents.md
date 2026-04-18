# Skill Routing

> gstack skills are the primary workflow tools. When a task matches a gstack skill,
> invoke it instead of answering directly. The skill has specialized workflows that
> produce better results than ad-hoc answers. ECC skills provide supporting patterns
> and standards that gstack skills call into when needed.

## Routing Table

| Task | gstack Skill | Supporting Skill |
|------|-------------|------------------|
| Implementation planning, ideation | `/office-hours`, `/blueprint` | -- |
| Architecture review, lock in design | `/plan-eng-review` | `api-design`, `backend-patterns` |
| Test-driven development | -- | `tdd-workflow`, `karpathy-guidelines` |
| Pre-landing code review | `/review` | `coding-standards`, `karpathy-guidelines` |
| Security audit | `/cso` | `security-review`, `security-scan` |
| Debugging, root cause | `/investigate` | -- |
| Browser QA, E2E testing | `/qa` | `e2e-testing` |
| Code quality dashboard | `/health` | `plankton-code-quality` |
| Documentation after shipping | `/document-release` | -- |
| Ship, deploy, create PR | `/ship`, `/land-and-deploy` | `deployment-patterns` |
| Performance regression | `/benchmark` | -- |
| Design system, visual audit | `/design-consultation`, `/design-review` | -- |
| Weekly retrospective | `/retro` | -- |
| Save/resume working state | `/checkpoint` | -- |

## Proactive Routing

When gstack proactive mode is enabled (default), skills are auto-invoked on intent. Key triggers:

- Coding, refactoring, and code review work should load `karpathy-guidelines` as a supporting skill.
- Bug, error, "why is this broken" → `/investigate`
- "Ship", "deploy", "create PR" → `/ship`
- "QA", "test the site", find bugs → `/qa`
- "Code review", "check my diff" → `/review`
- New idea, "is this worth building" → `/office-hours`
- "Think bigger", scope review → `/plan-ceo-review`
- "Safety mode", "be careful" → `/careful` or `/guard`
- "Debug", "fix this bug" → `/investigate`

## Parallel Task Execution

ALWAYS use parallel execution for independent operations:

```markdown
# GOOD: Parallel execution
Launch 3 tasks in parallel:
1. Security analysis of auth module (security-review skill)
2. Performance check (benchmark skill)
3. Code quality dashboard (health skill)

# BAD: Sequential when unnecessary
First task 1, then task 2, then task 3
```

## Multi-Perspective Review

For complex plans before implementation, use gstack's review pipeline:

- `/plan-ceo-review` -- strategy and scope
- `/plan-eng-review` -- architecture and edge cases (required for non-trivial changes)
- `/plan-design-review` -- UI/UX quality
- `/plan-devex-review` -- developer experience
- `/autoplan` -- run all reviews automatically
