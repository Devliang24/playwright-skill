import { expect, type Page } from '@playwright/test';

export class ExamplePage {
  constructor(private readonly page: Page) {}

  async goto(path = '/') {
    await this.page.goto(path);
  }

  async expectReady() {
    await expect(this.page.locator('body')).toBeVisible();
  }
}
