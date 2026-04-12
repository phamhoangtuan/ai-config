# Testing Requirements

## Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** -- Individual functions, utilities, components
2. **Integration Tests** -- API endpoints, database operations
3. **E2E Tests** -- Critical user flows

## Test-Driven Development

Use the `tdd-workflow` skill. Mandatory workflow:

1. Write test first (RED)
2. Run test -- it should FAIL
3. Write minimal implementation (GREEN)
4. Run test -- it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Browser-Based E2E Testing

Use `/qa` for browser-based QA testing via gstack's headless Chromium:
- Find bugs, fix, re-verify in one workflow
- Screenshots and before/after diffs as evidence
- Use `/qa-only` for report-only mode (no code changes)

For Playwright E2E patterns, use the `e2e-testing` skill.

## Troubleshooting Test Failures

1. Check test isolation
2. Verify mocks are correct
3. Fix implementation, not tests (unless tests are wrong)
4. Use `/investigate` for persistent failures to establish root cause
