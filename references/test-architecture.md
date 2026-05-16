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
- `trace: "retain-on-failure"`.
- `screenshot: "only-on-failure"`.
- `video: "retain-on-failure"`.
- HTML and list reporters.
- No remote runner config by default.
