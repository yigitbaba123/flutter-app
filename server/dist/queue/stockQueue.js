"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.stockWorker = exports.stockQueue = exports.STOCK_CHECK_QUEUE = void 0;
const bullmq_1 = require("bullmq");
const ioredis_1 = __importDefault(require("ioredis"));
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const redisConnection = new ioredis_1.default(process.env.REDIS_URL || 'redis://localhost:6379', {
    maxRetriesPerRequest: null,
});
exports.STOCK_CHECK_QUEUE = 'stock-check-queue';
exports.stockQueue = new bullmq_1.Queue(exports.STOCK_CHECK_QUEUE, {
    connection: redisConnection,
});
// Worker işlemi - Redis'e düşen görevleri (işleri) işlemek için
exports.stockWorker = new bullmq_1.Worker(exports.STOCK_CHECK_QUEUE, async (job) => {
    const { trackId, url, size, brand } = job.data;
    console.log(`[Worker] İşleniyor: ${brand} - ${url} - Beden: ${size} (Track: ${trackId})`);
    try {
        // Burada ileride ilgili markanın scraper'ı çalıştırılacak
        // Örn: const scraper = ScraperFactory.getScraper(brand);
        // const result = await scraper.scrape(url);
        // Geçici olarak başarılı sayıyoruz:
        console.log(`[Worker] İşlem tamamlandı: ${job.id}`);
    }
    catch (error) {
        console.error(`[Worker] Hata (Job ${job.id}):`, error);
        throw error;
    }
}, { connection: redisConnection });
exports.stockWorker.on('completed', job => {
    console.log(`[Worker] Görev başarıyla tamamlandı: ${job.id}`);
});
exports.stockWorker.on('failed', (job, err) => {
    console.error(`[Worker] Görev başarısız oldu: ${job?.id} - Hata: ${err.message}`);
});
