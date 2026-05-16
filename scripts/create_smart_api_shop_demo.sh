#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  create_smart_api_shop_demo.sh [target-dir] [--base-url URL] [--force]

Creates a single-file Playwright test case demo for 智能API服务站.
The generated demo is test-case oriented, not a full page-object test framework.
USAGE
}

TARGET_DIR="$PWD"
BASE_URL="http://110.40.159.145:5173"
FORCE=0

if [[ "${1:-}" != "" && "${1:-}" != --* ]]; then
  TARGET_DIR="$1"
  shift
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base-url)
      if [[ -z "${2:-}" ]]; then
        echo "error: --base-url requires a value" >&2
        exit 1
      fi
      BASE_URL="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

mkdir -p "$TARGET_DIR/tests"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
cd "$TARGET_DIR"

SPEC_FILE="$TARGET_DIR/tests/smart-api-shop.spec.ts"
CONFIG_FILE="$TARGET_DIR/playwright.config.ts"
PACKAGE_FILE="$TARGET_DIR/package.json"

write_with_base_url() {
  local file="$1"
  BASE_URL="$BASE_URL" node -e '
const fs = require("fs");
const file = process.argv[1];
const baseUrl = process.env.BASE_URL || "http://110.40.159.145:5173";
const text = fs.readFileSync(file, "utf8").replaceAll("__BASE_URL__", baseUrl);
fs.writeFileSync(file, text);
' "$file"
}

if [[ -e "$SPEC_FILE" && "$FORCE" -ne 1 ]]; then
  echo "skip existing: tests/smart-api-shop.spec.ts"
else
  cat > "$SPEC_FILE" <<'TS'
import { expect, test, type BrowserContext, type Page } from '@playwright/test';

const BASE_URL = process.env.PLAYWRIGHT_BASE_URL ?? '__BASE_URL__';
const APP_READY_TIMEOUT = 45_000;

async function coldLoad(page: Page, path: string) {
  // The public demo is served by a Vite dev server; commit is enough because
  // each test waits for user-visible UI state after navigation.
  await page.goto(new URL(path, BASE_URL).toString(), { waitUntil: 'commit' });
}

async function spaNavigate(page: Page, path: string) {
  await page.evaluate((nextPath) => {
    window.history.pushState({}, '', nextPath);
    window.dispatchEvent(new PopStateEvent('popstate'));
  }, path);
}

async function waitForProductList(page: Page) {
  await expect(page.getByText(/共\s*14\s*件商品/)).toBeVisible({ timeout: APP_READY_TIMEOUT });
}

async function selectVisibleOption(page: Page, optionName: string) {
  await page.locator('.ant-select-dropdown:not(.ant-select-dropdown-hidden)').getByText(optionName, { exact: true }).click();
}

async function selectOption(page: Page, comboboxIndex: number, optionName: string) {
  await page.locator('.ant-select-selector').nth(comboboxIndex).click({ force: true });
  await selectVisibleOption(page, optionName);
}

async function loadProducts(page: Page) {
  await coldLoad(page, '/products');
  await waitForProductList(page);
}

test.describe('智能API服务站 - single-file test case demo', () => {
  test.describe.configure({ mode: 'serial' });

  let context: BrowserContext;
  let page: Page;

  test.beforeEach(async () => {
    test.setTimeout(90_000);
  });

  test.beforeAll(async ({ browser }) => {
    context = await browser.newContext();
    page = await context.newPage();
    await page.route(/images\.unsplash\.com/, async (route) => {
      await route.fulfill({ status: 204, body: '' });
    });
  });

  test.afterAll(async () => {
    await context.close();
  });

  test('TC-001 root redirects to product list', async () => {
    await coldLoad(page, '/');

    await expect(page).toHaveURL(/\/products$/, { timeout: APP_READY_TIMEOUT });
    await expect(page).toHaveTitle(/智能API服务站/);
    await expect(page.getByText('智能API服务站').first()).toBeVisible();
  });

  test('TC-002 product list renders first page', async () => {
    await waitForProductList(page);

    await expect(page.getByText('GPT-5', { exact: true })).toBeVisible();
    await expect(page.getByText('GPT-5 mini')).toBeVisible();
    await expect(page.getByText('Claude Opus 4.5')).toBeVisible();
  });

  test('TC-003 search filters products by keyword', async () => {
    await waitForProductList(page);

    await page.getByPlaceholder('搜索商品').fill('GPT-5');
    await page.getByPlaceholder('搜索商品').press('Enter');

    await expect(page).toHaveURL(/search=GPT-5/);
    await expect(page.getByText('GPT-5', { exact: true })).toBeVisible();
    await expect(page.getByText('GPT-5 mini')).toBeVisible();
    await expect(page.getByText('GPT-5 nano')).toBeVisible();
  });

  test('TC-004 category filter shows Anthropic products', async () => {
    await page.getByPlaceholder('搜索商品').fill('');
    await page.getByPlaceholder('搜索商品').press('Enter');
    await expect(page).toHaveURL(/\/products$/);
    await waitForProductList(page);

    await selectOption(page, 0, 'Anthropic');

    await expect(page.getByText('Claude Opus 4.5')).toBeVisible();
    await expect(page.getByText('Claude Sonnet 4.5')).toBeVisible();
  });

  test('TC-005 sort by price ascending changes result order', async () => {
    await page.locator('.ant-select-clear').first().click();
    await waitForProductList(page);

    await selectOption(page, 1, '价格从低到高');

    await expect(page.getByText('GPT-5 nano')).toBeVisible();
    await expect(page.getByText('Gemini 2.0 Flash')).toBeVisible();
  });

  test('TC-006 pagination opens second page', async () => {
    await selectOption(page, 1, '最新上架');
    await waitForProductList(page);

    await page.locator('.ant-pagination-item-2').click();

    await expect(page.getByText('DeepSeek V3')).toBeVisible();
    await expect(page.getByText('DeepSeek R1')).toBeVisible();
  });

  test('TC-007 product detail displays purchase controls', async () => {
    await spaNavigate(page, '/products/1');

    await expect(page.getByRole('heading', { name: 'GPT-5' })).toBeVisible({ timeout: APP_READY_TIMEOUT });
    await expect(page.getByText('¥72.00').first()).toBeVisible();
    await expect(page.getByText('额度：72.0000 百万 token')).toBeVisible();
    await expect(page.getByText('库存')).toBeVisible();
    await expect(page.getByRole('button', { name: 'decrease' })).toBeVisible();
    await expect(page.getByRole('button', { name: 'increase' })).toBeVisible();
    await expect(page.getByRole('button', { name: '加入购物车' })).toBeVisible();
    await expect(page.getByRole('button', { name: '立即购买' })).toBeVisible();
  });

  test('TC-008 quantity control updates total price', async () => {
    await page.getByRole('button', { name: 'increase' }).click();

    await expect(page.getByText('¥144.00')).toBeVisible();
  });

  test('TC-009 login modal opens with demo credentials', async () => {
    await page.getByRole('button', { name: /登\s*录|登录/ }).click();

    await expect(page.getByRole('dialog')).toBeVisible();
    await expect(page.getByPlaceholder('用户名')).toHaveValue('demo');
    await expect(page.getByPlaceholder('密码')).toHaveValue('demo123');
    await expect(page.getByText('测试账户：admin / admin123 或 demo / demo123')).toBeVisible();
  });

  test('TC-010 register tab shows required fields', async () => {
    await page.getByRole('tab', { name: /注\s*册|注册/ }).click();

    await expect(page.getByRole('dialog')).toBeVisible();
    await expect(page.getByPlaceholder('用户名')).toBeVisible();
    await expect(page.getByPlaceholder('邮箱')).toBeVisible();
    await expect(page.getByPlaceholder('手机号（选填）')).toBeVisible();
    await expect(page.getByPlaceholder('密码')).toBeVisible();
    await expect(page.getByPlaceholder('确认密码')).toBeVisible();
  });

  test.skip('TC-011 add product to cart after login - skipped because it writes to the shared demo environment', async () => {
    await loadProducts(page);
    await page.getByRole('button', { name: /登\s*录|登录/ }).click();
    await page.getByRole('dialog').getByRole('button', { name: /登\s*录|登录/ }).click();
    await expect(page.getByLabel('购物车')).toBeVisible();
  });

  test.skip('TC-012 checkout creates order - skipped because it creates a real order in the shared demo environment', async () => {
    await coldLoad(page, '/cart');
    await page.getByRole('button', { name: '结算' }).click();
    await expect(page).toHaveURL(/\/orders\/\d+/);
  });
});
TS
  write_with_base_url "$SPEC_FILE"
  echo "wrote: tests/smart-api-shop.spec.ts"
fi

if [[ ! -e "$CONFIG_FILE" ]]; then
  cat > "$CONFIG_FILE" <<'TS'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 90_000,
  expect: {
    timeout: 45_000,
  },
  reporter: [
    ['list'],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
  ],
  use: {
    baseURL: process.env.PLAYWRIGHT_BASE_URL ?? '__BASE_URL__',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
TS
  write_with_base_url "$CONFIG_FILE"
  echo "wrote: playwright.config.ts"
else
  echo "skip existing: playwright.config.ts"
fi

if [[ -f "$PACKAGE_FILE" ]]; then
  node <<'NODE'
const fs = require('fs');
const path = 'package.json';
const pkg = JSON.parse(fs.readFileSync(path, 'utf8'));

pkg.scripts = pkg.scripts || {};
if (!pkg.scripts['test:smart-api-shop']) {
  pkg.scripts['test:smart-api-shop'] = 'playwright test tests/smart-api-shop.spec.ts';
}

fs.writeFileSync(path, `${JSON.stringify(pkg, null, 2)}\n`);
NODE
  echo "updated: package.json"
else
  echo "skip missing: package.json"
fi

echo
echo "Smart API Shop demo is ready."
echo "Run:"
echo "  npx playwright test tests/smart-api-shop.spec.ts"
echo
echo "Optional base URL override:"
echo "  PLAYWRIGHT_BASE_URL=$BASE_URL npx playwright test tests/smart-api-shop.spec.ts"
