# Project Intake

## Read-only inspection

Start with `scripts/inspect_project.sh <project-root>` or equivalent checks:

- `package.json` scripts and dependencies.
- Lockfile: `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lockb`.
- Existing Playwright config: `playwright.config.ts`, `.js`, `.mjs`, or `.mts`.
- Existing test directories: `tests`, `e2e`, `playwright`, `specs`.
- Frontend framework hints: Vite, Next.js, Remix, Nuxt, SvelteKit, Angular, Vue, React.

## Package manager

Prefer the package manager implied by the lockfile:

- `pnpm-lock.yaml` -> `pnpm`
- `yarn.lock` -> `yarn`
- `bun.lockb` -> `bun`
- `package-lock.json` or no lockfile -> `npm`

Do not replace or regenerate lockfiles unless the user asked to install dependencies and the install command naturally updates them.

## App startup

Prefer existing scripts in this order when choosing a local app command:

1. `dev`
2. `start`
3. `serve`
4. framework-specific scripts already documented in the repo

If the app URL is not discoverable, ask for it. Use `PLAYWRIGHT_BASE_URL` for overrides instead of hardcoding environment-specific URLs.

## Authentication

Do not hardcode usernames, passwords, tokens, or cookies in test files. Prefer:

- Existing test auth helpers.
- Environment variables.
- Playwright storage state generated from a local, user-approved login flow.

If login is required and no safe credential source exists, ask the user which source to use before writing login automation.
