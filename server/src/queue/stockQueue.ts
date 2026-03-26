import { Queue, Worker, Job } from 'bullmq';
import IORedis from 'ioredis';
import dotenv from 'dotenv';

dotenv.config();

const redisConnection = new IORedis(process.env.REDIS_URL || 'redis://localhost:6379', {
  maxRetriesPerRequest: null,
});

export const STOCK_CHECK_QUEUE = 'stock-check-queue';

export const stockQueue = new Queue(STOCK_CHECK_QUEUE, {
  connection: redisConnection as any,
});

// Worker işlemi - Redis'e düşen görevleri (işleri) işlemek için
export const stockWorker = new Worker(STOCK_CHECK_QUEUE, async (job: Job) => {
  const { trackId, url, size, brand } = job.data;
  
  console.log(`[Worker] İşleniyor: ${brand} - ${url} - Beden: ${size} (Track: ${trackId})`);
  
  try {
    // Burada ileride ilgili markanın scraper'ı çalıştırılacak
    // Örn: const scraper = ScraperFactory.getScraper(brand);
    // const result = await scraper.scrape(url);
    
    // Geçici olarak başarılı sayıyoruz:
    console.log(`[Worker] İşlem tamamlandı: ${job.id}`);
  } catch (error) {
    console.error(`[Worker] Hata (Job ${job.id}):`, error);
    throw error;
  }
}, { connection: redisConnection as any });

stockWorker.on('completed', job => {
  console.log(`[Worker] Görev başarıyla tamamlandı: ${job.id}`);
});

stockWorker.on('failed', (job, err) => {
  console.error(`[Worker] Görev başarısız oldu: ${job?.id} - Hata: ${err.message}`);
});
