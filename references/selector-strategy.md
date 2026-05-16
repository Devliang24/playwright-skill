# Selector Strategy

## Priority order

Prefer selectors in this order:

1. `getByRole` with accessible name.
2. `getByLabel`.
3. `getByPlaceholder`.
4. `getByText` for stable visible copy.
5. `getByTestId` when the app already uses test IDs or when adding one is acceptable.
6. Narrow CSS selectors only when no accessible locator is practical.
7. XPath only as a last resort.

## Stability rules

- Assert user-visible outcomes, not internal DOM structure.
- Avoid generated class names, nth-child chains, and animation timing.
- Prefer route-aware waits and web-first assertions over fixed sleeps.
- If a locator is hard to express, consider adding an accessible label or `data-testid` in the app code.

## Naming test IDs

When adding test IDs, use names that describe product meaning:

```text
login-submit
user-menu
search-input
checkout-total
```

Do not encode layout or styling in test IDs.
