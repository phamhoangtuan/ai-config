# Performance

## Performance Regression Detection

Use `/benchmark` to establish baselines and detect regressions:
- Page load times and Core Web Vitals
- Resource and bundle sizes
- Before/after comparisons on every PR
- Performance trend tracking over time

## Build Troubleshooting

If build fails:
1. Use `/investigate` for systematic root-cause analysis
2. Analyze error messages
3. Fix incrementally
4. Verify after each fix

Iron Law: no fixes without establishing root cause first.

## Context Window Management

Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks (safe near window limit):
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes
