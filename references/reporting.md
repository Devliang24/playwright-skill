# Local Reporting

## Artifacts

Default local artifacts:

- HTML report: `playwright-report/`
- Raw results and traces: `test-results/`
- Screenshots: retained on failure.
- Videos: retained on failure.
- Traces: retained on failure.

## Useful commands

```bash
npx playwright test --headed
npx playwright test tests/specs/smoke.spec.ts --headed
npx playwright test --debug
npx playwright show-report
```

Use the package manager wrapper when the repo defines scripts:

```bash
npm run test:e2e
pnpm test:e2e
yarn test:e2e
bun run test:e2e
```

## Failure diagnosis

Read failure output first, then inspect artifacts:

1. Error message and failing assertion.
2. Screenshot at failure.
3. Trace timeline and locator snapshots.
4. Video if timing or animation seems involved.

Prefer fixing the app-accessible selector or the test's user-level expectation over adding sleeps.
