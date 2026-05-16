import { test as base } from '@playwright/test';
import { ExamplePage } from '../pages/example.page';

type AppFixtures = {
  examplePage: ExamplePage;
};

export const test = base.extend<AppFixtures>({
  examplePage: async ({ page }, use) => {
    await use(new ExamplePage(page));
  },
});

export { expect } from '@playwright/test';
