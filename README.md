# Playwright Skill

A Codex skill for creating, extending, and debugging local Playwright UI automation tests for web apps.

Playwright Skill helps Codex inspect a frontend project, choose a sensible Playwright structure, scaffold a TypeScript test baseline, stabilize selectors, and diagnose failing browser tests with local reports, traces, screenshots, and videos.

## What This Skill Does

- Adds a maintainable Playwright Test setup to web projects.
- Generates a small smoke test, fixture, and page object baseline.
- Guides Codex through project intake before changing files.
- Encourages stable, accessibility-first locators.
- Helps debug failed Playwright runs using local artifacts.
- Keeps the workflow focused on local browser testing and reporting.

## When To Use It

Use this skill when you want Codex to:

- Add Playwright UI tests to an existing web app.
- Create a smoke test for a local app or public URL.
- Refactor brittle selectors into stable locators.
- Introduce page objects or Playwright fixtures.
- Investigate a failed Playwright test from logs, screenshots, traces, or videos.

Example prompts:

```text
Use $playwright-skill to add Playwright UI automation tests to this web project.
```

```text
使用 $playwright-skill 给当前项目加一套 Playwright 冒烟测试。
```

```text
Use $playwright-skill to debug this failing Playwright spec and explain the failure artifact.
```

## Installation

Clone the repository into your Codex skills directory:

```bash
mkdir -p ~/.codex/skills
git clone https://github.com/Devliang24/playwright-skill.git ~/.codex/skills/playwright-skill
```

Then start a new Codex session and invoke it with:

```text
Use $playwright-skill to add Playwright UI automation tests to this web project.
```

## Repository Structure

```text
playwright-skill/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── project-intake.md
│   ├── reporting.md
│   ├── selector-strategy.md
│   ├── test-architecture.md
│   └── user-interaction.md
├── scripts/
│   ├── inspect_project.sh
│   └── scaffold_playwright.sh
└── assets/
    └── playwright-template/
        ├── playwright.config.ts
        ├── package-scripts.snippet.json
        └── tests/
            ├── fixtures/
            ├── pages/
            └── specs/
```

## Included Scripts

Inspect a project without changing it:

```bash
./scripts/inspect_project.sh /path/to/web-project
```

Scaffold a local Playwright baseline:

```bash
./scripts/scaffold_playwright.sh /path/to/web-project --base-url http://localhost:3000
```

The scaffold script copies the template files and adds local Playwright npm scripts when they are missing. It does not install dependencies for you.

## Generated Playwright Baseline

The template creates:

- `playwright.config.ts`
- `tests/specs/smoke.spec.ts`
- `tests/fixtures/app.fixture.ts`
- `tests/pages/example.page.ts`
- npm scripts such as `test:e2e`, `test:e2e:headed`, `test:e2e:debug`, and `test:e2e:report`

After scaffolding, install Playwright in the target project with its package manager:

```bash
npm install -D @playwright/test
npx playwright install
npm run test:e2e
```

Use the equivalent `pnpm`, `yarn`, or `bun` commands when the project already uses one of those package managers.

## Skill Principles

- Inspect first, edit second.
- Ask only for missing product intent.
- Prefer user-visible assertions over DOM internals.
- Prefer `getByRole`, `getByLabel`, and other accessible locators.
- Keep smoke tests small before expanding coverage.
- Never hardcode credentials or secrets into tests.

## Development

Validate the skill structure with the Codex skill creator validator:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```

Run shell syntax checks:

```bash
bash -n scripts/inspect_project.sh
bash -n scripts/scaffold_playwright.sh
```
