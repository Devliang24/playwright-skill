# Playwright Skill

一个用于创建、扩展和调试本地 Playwright UI 自动化测试的 Codex Skill。

Playwright Skill 可以帮助 Codex 先检查前端项目，再选择合适的 Playwright 测试结构，生成 TypeScript 测试基线，稳定选择器，并结合本地 report、trace、截图和视频来定位失败用例。

## 能做什么

- 为 Web 项目添加可维护的 Playwright Test 配置。
- 生成最小可用的 smoke 测试、fixture 和 page object。
- 为外部 URL 生成单文件、测试用例颗粒度的 Playwright 演示脚本。
- 默认以打开浏览器的 headed 模式编写和执行用例，方便观察真实 UI。
- 在修改文件前，引导 Codex 先完成项目信息采集。
- 鼓励使用稳定、可访问性优先的 locator。
- 根据本地失败产物调试 Playwright 用例。
- 聚焦本地浏览器测试和本地报告。

## 什么时候使用

当你希望 Codex 完成这些任务时，可以使用这个 skill：

- 给已有 Web 应用添加 Playwright UI 测试。
- 为本地应用或公开 URL 创建 smoke 测试。
- 为外部演示站点生成 `TC-001`、`TC-002` 这类测试用例粒度的单脚本 demo。
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
│   ├── create_smart_api_shop_demo.sh
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

生成“智能API服务站”的单脚本测试用例演示：

```bash
./scripts/create_smart_api_shop_demo.sh /path/to/demo-project
```

指定被测地址：

```bash
./scripts/create_smart_api_shop_demo.sh /path/to/demo-project --base-url http://110.40.159.145:5173
```

这个脚本会生成 `tests/smart-api-shop.spec.ts`，用 `TC-001`、`TC-002` 这样的测试用例颗粒度组织断言，不拆 page object 或完整业务测试框架。

## 生成的 Playwright 基线

模板会生成：

- `playwright.config.ts`
- `tests/specs/smoke.spec.ts`
- `tests/fixtures/app.fixture.ts`
- `tests/pages/example.page.ts`
- `test:e2e`、`test:e2e:headed`、`test:e2e:debug`、`test:e2e:report` 等 npm scripts

默认配置会设置 `headless: false`，`test:e2e` 也会使用 `playwright test --headed`，因此本地执行时会打开浏览器窗口。

脚手架生成后，在目标项目中按项目使用的包管理器安装 Playwright：

```bash
npm install -D @playwright/test
npx playwright install
npm run test:e2e
```

如果项目使用 `pnpm`、`yarn` 或 `bun`，请使用对应命令。

## 智能API服务站单脚本演示

这个演示用于说明 `$playwright-skill` 如何面对一个公开 URL，把测试收敛到“测试用例颗粒度”，而不是生成完整业务自动化框架。它适合 demo、POC、教学和快速验证场景。

可以让 Codex 通过下面的 prompt 触发：

```text
使用 $playwright-skill，以 http://110.40.159.145:5173/ 作为测试对象，生成单脚本 Playwright 测试用例演示。
```

Codex 的预期行为：

- 加载 `$playwright-skill`。
- 识别这是外部站点 demo，而不是长期维护测试工程。
- 调用或参考 `scripts/create_smart_api_shop_demo.sh`。
- 生成一个自包含的 `tests/smart-api-shop.spec.ts`。
- 运行默认非写入用例，并返回通过数、跳过数和失败产物路径。

也可以直接运行脚本：

```bash
./scripts/create_smart_api_shop_demo.sh . --base-url http://110.40.159.145:5173
```

脚本参数：

```bash
./scripts/create_smart_api_shop_demo.sh [target-dir] [--base-url URL] [--force]
```

默认被测地址是 `http://110.40.159.145:5173`。如果目标目录已经有 `tests/smart-api-shop.spec.ts`，脚本默认不会覆盖；需要覆盖时加 `--force`。

生成内容：

```text
tests/smart-api-shop.spec.ts
playwright.config.ts        # 仅当目标目录不存在配置时生成
package.json                # 仅当需要补 npm scripts 且目标目录已有 package.json 时更新
```

如果目标目录已有 `package.json`，脚本会补充：

```json
{
  "scripts": {
    "test:smart-api-shop": "playwright test tests/smart-api-shop.spec.ts --headed"
  }
}
```

运行命令：

```bash
npx playwright test tests/smart-api-shop.spec.ts --headed
```

或：

```bash
npm run test:smart-api-shop
```

默认测试用例：

- `TC-001`：根路径跳转到商品列表。
- `TC-002`：商品列表首页渲染。
- `TC-003`：按关键字搜索商品。
- `TC-004`：按 `Anthropic` 分类筛选商品。
- `TC-005`：按价格从低到高排序。
- `TC-006`：打开第 2 页分页。
- `TC-007`：商品详情展示购买控件。
- `TC-008`：数量加一后合计价格更新。
- `TC-009`：登录弹窗展示 demo 账号。
- `TC-010`：注册 tab 展示必填字段。
- `TC-011`：登录后加入购物车，默认 `test.skip`。
- `TC-012`：结算创建订单，默认 `test.skip`。

`TC-011` 和 `TC-012` 默认跳过，因为它们会写入共享演示环境。只有用户明确允许写入购物车或创建订单时，才应该打开这些用例。

这个 demo 有意不引入 page object、fixture 或 `pages/fixtures/utils` 长期维护目录。若要把它升级为长期回归测试，再按项目规模拆分结构。

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
bash -n scripts/create_smart_api_shop_demo.sh
```
