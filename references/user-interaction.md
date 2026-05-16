# User Interaction

## Trigger examples

Users may ask in English or Chinese:

- "Use $playwright-skill to add UI tests to this project."
- "给这个项目加 Playwright UI 自动化测试。"
- "帮我为 https://example.com 写冒烟测试。"
- "调试这个失败的 Playwright 用例。"
- "把这些脆弱选择器改稳定。"

## Conversation flow

1. Inspect before asking. Derive project type, package manager, scripts, and existing Playwright setup from files when possible.
2. Ask only for missing intent. Keep questions short and ask no more than three at a time.
3. If the user asks for a plan, stop at a concrete plan. If the user asks to execute, make the changes and run verification.
4. Report in the user's language. For Chinese prompts, answer in Chinese unless the repo content makes English clearer.

## High-value questions

Ask these only when they cannot be discovered:

- What URL should the tests target?
- Which command starts the app locally?
- Is login required for the core path?
- Where should credentials come from: environment variables, a test account already configured in the repo, or manual login state?
- Which user path matters first: smoke load, login, search, checkout, admin workflow, or another path?

## Result format

For implementation tasks, end with:

- Files changed.
- Test command run.
- Pass/fail summary.
- Local report path, trace path, screenshot path, or video path when relevant.
- Any remaining manual input needed.

For debugging tasks, lead with the root cause or strongest hypothesis, then the smallest fix and the command used to verify it.
