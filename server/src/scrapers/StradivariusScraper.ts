import { chromium, Browser, Page } from 'playwright';
import { IScraper, ProductDetails, SizeVariant } from '../types/scraper';

export class StradivariusScraper implements IScraper {
  brand = 'STRADIVARIUS';

  canHandle(url: string): boolean {
    return url.toLowerCase().includes('stradivarius.com');
  }

  async scrape(url: string): Promise<ProductDetails> {
    let browser: Browser | null = null;
    
    try {
      // Chromium'u headless modda başlatıyoruz
      browser = await chromium.launch({ headless: true });
      const context = await browser.newContext({
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1', 
        viewport: { width: 390, height: 844 }, // Mobil görünüm bot korumasını daha kolay aşar
      });
      
      const page: Page = await context.newPage();
      
      console.log(`[StradivariusScraper] Sayfaya gidiliyor: ${url}`);
      await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
      
      // Sayfa tam yüklenene kadar bekle
      await page.waitForTimeout(3000); 

      // Ürün adını çekme (Genellikle h1 etiketindedir)
      const nameElement = await page.$('h1');
      const name = nameElement ? await nameElement.innerText() : 'Bilinmeyen Ürün';

      // Ürün fiyatını çekme 
      const priceElement = await page.$('.price, [data-qa="product-price"]');
      const price = priceElement ? await priceElement.innerText() : 'Bilinmiyor';

      // İlk ürün resmini çekme
      const imageElement = await page.$('img');
      const imageUrl = imageElement ? await imageElement.getAttribute('src') || '' : '';

      // Bedenleri Çekme
      // (Burası Stradivarius'un anlık DOM yapısına göre uyarlanmalıdır. Şimdilik örnek bir seçici kullanıyoruz.)
      const sizes: SizeVariant[] = [];
      const sizeButtons = await page.$$('.size-button, [data-qa="size-selector"] li');
      
      for (const btn of sizeButtons) {
        const sizeName = await btn.innerText();
        
        // Üstü çizili veya pasif class'ı var mı kontrolü (Stokta yok)
        const classStr = await btn.getAttribute('class') || '';
        const inStock = !classStr.includes('out-of-stock') && !classStr.includes('disabled');

        sizes.push({
          name: sizeName.trim(),
          inStock
        });
      }

      return {
        url,
        brand: this.brand,
        name: name.trim(),
        price: price.trim(),
        imageUrl,
        sizes
      };

    } catch (error) {
      console.error(`[StradivariusScraper] Scraping Hatası - ${url}:`, error);
      throw error;
    } finally {
      if (browser) {
        await browser.close();
      }
    }
  }
}
