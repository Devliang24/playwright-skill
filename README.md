# Playwright Skill

一个用于创建、扩展和调试本地 Playwright UI 自动化测试的 Codex Skill。

Playwright Skill 可以帮助 Codex 先检查前端项目，再选择合适的 Playwright 测试结构，生成 TypeScript 测试基线，稳定选择器，并结合本地 report、trace、截图和视频来定位失败用例。

## 能做什么

- 为 Web 项目添加可维护的 Playwright Test 配置。
- 生成最小可用的 smoke 测试、fixture 和 page object。
- 在修改文件前，引导 Codex 先完成项目信息采集。
- 鼓励使用稳定、可访问性优先的 locator。
- 根据本地失败产物调试 Playwright 用例。
- 聚焦本地浏览器测试和本地报告。

## 什么时候使用

当你希望 Codex 完成这些任务时，可以使用这个 skill：

- 给已有 Web 应用添加 Playwright UI 测试。
- 为本地应用或公开 URL 创建 smoke 测试。
- 把脆弱选择器重构成稳定 locator。
- 引入 page object 或 Playwright fixture。
- 根据日志、截图、trace、视频分析失败的 Playwright 测试。

示例：

```text
使用 $playwright-skill 给当前项目加一套 Playwright UI 自动化测试。
```

```text
使用 $playwright-skill 为 https://example.com 写一个冒烟测试。
```

```text
使用 $playwright-skill 调试这个失败的 Playwright 用例，并说明失败原因。
```

## 安装

把仓库克隆到 Codex skills 目录：

```bash
mkdir -p ~/.codex/skills
git clone https://github.com/Devliang24/playwright-skill.git ~/.codex/skills/playwright-skill
```

然后开启新的 Codex 会话，通过下面的方式调用：

```text
使用 $playwright-skill 给当前项目加一套 Playwright UI 自动化测试。
```

## 仓库结构

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

## 内置脚本

只读检查项目，不修改文件：

```bash
./scripts/inspect_project.sh /path/to/web-project
```

生成本地 Playwright 测试基线：

```bash
./scripts/scaffold_playwright.sh /path/to/web-project --base-url http://localhost:3000
```

`scaffold_playwright.sh` 会复制模板文件，并在缺少对应命令时补充本地 Playwright npm scripts。它不会自动安装依赖。

## 生成的 Playwright 基线

模板会生成：

- `playwright.config.ts`
- `tests/specs/smoke.spec.ts`
- `tests/fixtures/app.fixture.ts`
- `tests/pages/example.page.ts`
- `test:e2e`、`test:e2e:headed`、`test:e2e:debug`、`test:e2e:report` 等 npm scripts

脚手架生成后，在目标项目中按项目使用的包管理器安装 Playwright：

```bash
npm install -D @playwright/test
npx playwright install
npm run test:e2e
```

如果项目使用 `pnpm`、`yarn` 或 `bun`，请使用对应命令。

## Skill 原则

- 先检查项目，再修改文件。
- 只在缺少产品意图时提问。
- 优先断言用户可见结果，而不是内部 DOM 结构。
- 优先使用 `getByRole`、`getByLabel` 等可访问性 locator。
- 先保证 smoke 测试稳定，再扩展覆盖面。
- 不把账号、密码、token 等敏感信息硬编码进测试。

## 开发与校验

校验 skill 结构：

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```

检查 shell 脚本语法：

```bash
bash -n scripts/inspect_project.sh
bash -n scripts/scaffold_playwright.sh
```
