# Test Architecture

## Default layout

For new setups, use:

```text
tests/
├── specs/
├── pages/
├── fixtures/
└── utils/
```

Use existing project conventions when they already differ and are coherent.

## Demo and POC exception

For an external URL demo, proof of concept, or throwaway showcase, prefer a single spec file organized by test case IDs. Do not introduce page objects, fixtures, or a long-lived folder structure unless the user asks to turn the demo into maintained regression coverage.

For example:

```text
tests/
└── smart-api-shop.spec.ts
```

Keep each test focused on one observable behavior and name it with `TC-001`, `TC-002`, and so on.

## Spec files

Spec files describe user behavior, not implementation details. Keep a first smoke spec small:

- App shell loads.
- Primary navigation or landing route is visible.
- One core path works only if the user provided enough intent.

Avoid large end-to-end flows until the startup command, base URL, and selectors are stable.

## Page objects

Use page objects when:

- The same page or component appears in more than one spec.
- The flow has repeated waits, navigation, or assertions.
- The selectors need a stable home.

Keep page objects thin. They should expose user actions and meaningful assertions, not mirror every DOM node.

## Fixtures

Use Playwright fixtures for:

- Shared page objects.
- Authenticated context.
- Test data setup that is local and deterministic.

Do not hide important user flow steps in fixtures unless they are true setup, such as loading storage state.

## Configuration defaults

For a first setup:

- One project: Chromium.
- Headed browser execution by default: `headless: false`.
- `trace: "retain-on-failure"`.
- `screenshot: "only-on-failure"`.
- `video: "retain-on-failure"`.
- HTML and list reporters.
- No remote runner config by default.
