import { Request, Response } from 'express';
import { extractBrandFromUrl } from '../utils/urlParser';
import { StradivariusScraper } from '../scrapers/StradivariusScraper';
import { stockQueue } from '../queue/stockQueue';
import prisma from '../prismaClient';

export const trackProduct = async (req: Request, res: Response): Promise<void> => {
  try {
    const { url, size, userId } = req.body;

    if (!url || !size || !userId) {
      res.status(400).json({ error: 'url, size ve userId zorunludur.' });
      return;
    }

    const brandName = extractBrandFromUrl(url);

    // TODO: İleride ScraperFactory ile markaya özel scraper seçilecek. Şimdilik sadece Stradivarius üzerinden test ediyoruz:
    let productDetails;
    if (brandName === 'STRADIVARIUS') {
      const scraper = new StradivariusScraper();
      productDetails = await scraper.scrape(url);
    } else {
      // Diğer markalar için MVP'de Dummy Veri
      productDetails = {
        url,
        brand: brandName as any,
        name: 'MVP Test Ürünü',
        imageUrl: 'https://via.placeholder.com/150',
        sizes: [{ name: size, inStock: false }]
      };
    }

    // 1. Kullanıcıyı db'de yoksa (MVP için mock auth nedeniyle) anonim olarak oluştur/bul
    let user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      // Front-end'in yolladığı userId ile test kullanıcısı oluştur
      user = await prisma.user.create({
        data: {
          id: userId,
          email: `${userId}@test.com`,
          role: 'USER',
        }
      });
    }

    // 2. Ürünü veritabanına kaydet veya bul
    let product = await prisma.product.findUnique({ where: { url } });
    if (!product) {
      product = await prisma.product.create({
        data: {
          url,
          name: productDetails.name,
          brand: brandName as any,
          imageUrl: productDetails.imageUrl,
        }
      });
    }

    // 3. Takip (Track) kaydını oluştur
    const existingTrack = await prisma.track.findFirst({
      where: { userId: user.id, productId: product.id, size }
    });

    if (existingTrack) {
      res.status(409).json({ error: 'Bu beden zaten takip ediliyor.' });
      return;
    }

    const track = await prisma.track.create({
      data: {
        userId: user.id,
        productId: product.id,
        size
      }
    });

    // 4. Redis kuyruğuna stok kontrol görevini ekle (Her 15 dakikada bir kontrol eder)
    await stockQueue.add('check-stock', {
      trackId: track.id,
      url,
      size,
      brand: brandName
    }, {
      repeat: {
        pattern: '*/15 * * * *' // Her 15 dakikada bir
      }
    });

    res.status(201).json({
      message: 'Takip başarıyla başlatıldı ve arka plan kuyruğuna eklendi.',
      track,
      product: productDetails
    });

  } catch (error: any) {
    console.error('[trackController] Hata:', error);
    res.status(500).json({ error: 'Sunucu hatası: ' + error.message });
  }
};
