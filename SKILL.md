---
name: playwright-skill
description: Build, extend, and debug Playwright UI automation tests for web apps. Use when Codex is asked to add Playwright tests, create browser UI smoke or regression tests, inspect a frontend project for UI testing, generate a single-file external URL demo, stabilize selectors, create page objects or fixtures, run local Playwright tests, or diagnose failing Playwright traces, screenshots, videos, or reports. Supports natural-language requests in English or Chinese such as "给这个项目加 UI 自动化测试" or "生成单脚本 Playwright 测试用例演示".
---

# Playwright Skill

## Overview

Use this skill to turn a web project or URL into a maintainable local Playwright UI automation setup. Keep the workflow project-aware: inspect first, ask only for missing product intent, then make focused test changes and verify them locally.

This skill focuses on local Playwright testing, reports, and failure artifacts.

## Workflow

1. Inspect the project before editing. Run `scripts/inspect_project.sh <project-root>` or perform equivalent read-only checks for package manager, framework, start scripts, existing Playwright config, and tests.
2. Classify the request as one of: new setup, external URL demo, new test coverage, failure debugging, selector stabilization, page-object cleanup, or local reporting.
3. Ask at most 1-3 concise questions only when the repo cannot reveal the answer. Common missing inputs are base URL, start command, login method, credential source, and core user path.
4. Load only the reference files needed for the task:
   - User interaction and response shape: `references/user-interaction.md`
   - Project intake checklist: `references/project-intake.md`
   - Test structure and defaults: `references/test-architecture.md`
   - Locator strategy: `references/selector-strategy.md`
   - Local reports and failure artifacts: `references/reporting.md`
5. Implement with the repo's existing package manager, TypeScript settings, and naming conventions. If no Playwright setup exists, use `assets/playwright-template/` or `scripts/scaffold_playwright.sh`.
6. Run the narrowest useful local verification, usually `npx playwright test` or a single spec. Report pass/fail counts, report path, and the most useful failure artifact.

## External Site Demo Mode

When the user asks for a demo against an external URL, prefer a single self-contained spec file over a full framework. Organize the file by test case IDs such as `TC-001`, `TC-002`, and `TC-003`; each test should validate one user-observable behavior.

For the 智能API服务站 demo target, use:

```bash
<skill-root>/scripts/create_smart_api_shop_demo.sh <project-root> --base-url http://110.40.159.145:5173
```

This creates `tests/smart-api-shop.spec.ts`. It intentionally keeps the demo at test-case granularity and skips write-heavy cases such as adding to cart or creating orders unless the user explicitly enables them.

## Defaults

- Use Playwright Test with TypeScript.
- Prefer Chromium for the first working baseline. Add Firefox or WebKit only when requested or already present.
- Use `tests/specs`, `tests/pages`, `tests/fixtures`, and `tests/utils` when creating a new structure.
- Prefer accessible locators: `getByRole`, `getByLabel`, `getByPlaceholder`, `getByText`, then `getByTestId`. Avoid brittle CSS and XPath unless the UI gives no stable alternative.
- Do not hardcode secrets. Use environment variables or existing project secret handling.
- Keep smoke tests small and deterministic; broaden coverage only after the first reliable path passes.

## Local Scaffolding

When the user asks to create a fresh Playwright setup and the project has no existing one:

```bash
<skill-root>/scripts/scaffold_playwright.sh <project-root> --base-url http://localhost:3000
```

After scaffolding, install Playwright using the project's package manager if it is not already installed:

```bash
npm install -D @playwright/test
npx playwright install
```

Use the equivalent `pnpm`, `yarn`, or `bun` commands when the project already uses that package manager.

## Response Contract

Final responses should state what changed, how it was verified, and where local Playwright artifacts are. If verification could not run, say exactly why and give the next command the user can run.
