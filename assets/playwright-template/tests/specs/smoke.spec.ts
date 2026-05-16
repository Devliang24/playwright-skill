import { test } from '../fixtures/app.fixture';

test.describe('application smoke', () => {
  test('loads the app shell', async ({ examplePage }) => {
    await examplePage.goto();
    await examplePage.expectReady();
  });
});
