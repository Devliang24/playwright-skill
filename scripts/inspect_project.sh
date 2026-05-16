#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$PWD}"

if [[ ! -d "$ROOT" ]]; then
  echo "error: project root does not exist: $ROOT" >&2
  exit 1
fi

cd "$ROOT"

echo "project_root: $(pwd)"

echo
echo "package_manager:"
if [[ -f pnpm-lock.yaml ]]; then
  echo "  pnpm"
elif [[ -f yarn.lock ]]; then
  echo "  yarn"
elif [[ -f bun.lockb ]]; then
  echo "  bun"
elif [[ -f package-lock.json ]]; then
  echo "  npm"
else
  echo "  unknown"
fi

echo
echo "package_json:"
if [[ -f package.json ]]; then
  echo "  found"
  if command -v node >/dev/null 2>&1; then
    node <<'NODE'
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
const scripts = pkg.scripts || {};
const deps = { ...(pkg.dependencies || {}), ...(pkg.devDependencies || {}) };
const interestingScripts = ['dev', 'start', 'serve', 'preview', 'test', 'test:e2e', 'e2e'];
const frameworks = ['next', 'vite', 'react', 'vue', 'nuxt', 'svelte', '@sveltejs/kit', '@angular/core', '@remix-run/react', '@playwright/test'];

console.log('  scripts:');
for (const key of interestingScripts) {
  if (scripts[key]) console.log(`    ${key}: ${scripts[key]}`);
}

console.log('  detected_dependencies:');
for (const name of frameworks) {
  if (deps[name]) console.log(`    ${name}: ${deps[name]}`);
}
NODE
  fi
else
  echo "  missing"
fi

echo
echo "playwright_config:"
shopt -s nullglob
configs=(playwright.config.*)
if (( ${#configs[@]} > 0 )); then
  for config in "${configs[@]}"; do
    echo "  $config"
  done
else
  echo "  none"
fi

echo
echo "test_directories:"
for dir in tests e2e playwright specs; do
  if [[ -d "$dir" ]]; then
    echo "  $dir"
  fi
done
