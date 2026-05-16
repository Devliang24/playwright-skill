#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  scaffold_playwright.sh <project-root> [--base-url URL] [--force]

Creates a minimal local Playwright Test structure from this skill's template.
It does not install dependencies or add remote runner configuration.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 ]]; then
  usage >&2
  exit 1
fi

PROJECT_ROOT="$1"
shift

BASE_URL="http://localhost:3000"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base-url)
      BASE_URL="${2:-}"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "$PROJECT_ROOT" ]]; then
  echo "error: project root does not exist: $PROJECT_ROOT" >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "error: node is required to scaffold Playwright files" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_ROOT="$SKILL_ROOT/assets/playwright-template"

if [[ ! -d "$TEMPLATE_ROOT" ]]; then
  echo "error: template directory missing: $TEMPLATE_ROOT" >&2
  exit 1
fi

cd "$PROJECT_ROOT"

while IFS= read -r -d '' source_file; do
  relative_path="${source_file#$TEMPLATE_ROOT/}"
  if [[ "$relative_path" == "package-scripts.snippet.json" ]]; then
    continue
  fi

  target_file="$PROJECT_ROOT/$relative_path"
  if [[ -e "$target_file" && "$FORCE" -ne 1 ]]; then
    echo "skip existing: $relative_path"
    continue
  fi

  mkdir -p "$(dirname "$target_file")"
  BASE_URL="$BASE_URL" node -e '
const fs = require("fs");
const [source, target] = process.argv.slice(1);
const baseUrl = process.env.BASE_URL || "http://localhost:3000";
const text = fs.readFileSync(source, "utf8").replaceAll("__BASE_URL__", baseUrl);
fs.writeFileSync(target, text);
' "$source_file" "$target_file"
  echo "wrote: $relative_path"
done < <(find "$TEMPLATE_ROOT" -type f -print0)

node <<'NODE'
const fs = require('fs');
const path = 'package.json';
const scripts = {
  'test:e2e': 'playwright test --headed',
  'test:e2e:headed': 'playwright test --headed',
  'test:e2e:debug': 'playwright test --debug',
  'test:e2e:report': 'playwright show-report'
};

const pkg = fs.existsSync(path)
  ? JSON.parse(fs.readFileSync(path, 'utf8'))
  : { private: true, scripts: {} };

pkg.scripts = pkg.scripts || {};
for (const [key, value] of Object.entries(scripts)) {
  if (!pkg.scripts[key] || (key === 'test:e2e' && pkg.scripts[key] === 'playwright test')) {
    pkg.scripts[key] = value;
  }
}

fs.writeFileSync(path, `${JSON.stringify(pkg, null, 2)}\n`);
NODE

echo
echo "Playwright scaffold complete."
echo "Next:"
echo "  install @playwright/test with this project's package manager"
echo "  run: npx playwright install"
echo "  run: PLAYWRIGHT_BASE_URL=$BASE_URL npx playwright test --headed"
