"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.trackProduct = void 0;
const urlParser_1 = require("../utils/urlParser");
const StradivariusScraper_1 = require("../scrapers/StradivariusScraper");
const stockQueue_1 = require("../queue/stockQueue");
const prismaClient_1 = __importDefault(require("../prismaClient"));
const trackProduct = async (req, res) => {
    try {
        const { url, size, userId } = req.body;
        if (!url || !size || !userId) {
            res.status(400).json({ error: 'url, size ve userId zorunludur.' });
            return;
        }
        const brandName = (0, urlParser_1.extractBrandFromUrl)(url);
        // TODO: İleride ScraperFactory ile markaya özel scraper seçilecek. Şimdilik sadece Stradivarius üzerinden test ediyoruz:
        let productDetails;
        if (brandName === 'STRADIVARIUS') {
            const scraper = new StradivariusScraper_1.StradivariusScraper();
            productDetails = await scraper.scrape(url);
        }
        else {
            // Diğer markalar için MVP'de Dummy Veri
            productDetails = {
                url,
                brand: brandName,
                name: 'MVP Test Ürünü',
                imageUrl: 'https://via.placeholder.com/150',
                sizes: [{ name: size, inStock: false }]
            };
        }
        // 1. Kullanıcıyı db'de yoksa (MVP için mock auth nedeniyle) anonim olarak oluştur/bul
        let user = await prismaClient_1.default.user.findUnique({ where: { id: userId } });
        if (!user) {
            // Front-end'in yolladığı userId ile test kullanıcısı oluştur
            user = await prismaClient_1.default.user.create({
                data: {
                    id: userId,
                    email: `${userId}@test.com`,
                    role: 'USER',
                }
            });
        }
        // 2. Ürünü veritabanına kaydet veya bul
        let product = await prismaClient_1.default.product.findUnique({ where: { url } });
        if (!product) {
            product = await prismaClient_1.default.product.create({
                data: {
                    url,
                    name: productDetails.name,
                    brand: brandName,
                    imageUrl: productDetails.imageUrl,
                }
            });
        }
        // 3. Takip (Track) kaydını oluştur
        const existingTrack = await prismaClient_1.default.track.findFirst({
            where: { userId: user.id, productId: product.id, size }
        });
        if (existingTrack) {
            res.status(409).json({ error: 'Bu beden zaten takip ediliyor.' });
            return;
        }
        const track = await prismaClient_1.default.track.create({
            data: {
                userId: user.id,
                productId: product.id,
                size
            }
        });
        // 4. Redis kuyruğuna stok kontrol görevini ekle (Her 15 dakikada bir kontrol eder)
        await stockQueue_1.stockQueue.add('check-stock', {
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
    }
    catch (error) {
        console.error('[trackController] Hata:', error);
        res.status(500).json({ error: 'Sunucu hatası: ' + error.message });
    }
};
exports.trackProduct = trackProduct;
