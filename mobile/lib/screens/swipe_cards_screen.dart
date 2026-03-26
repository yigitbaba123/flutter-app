import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

// ──────────────────────────────────────────
//  Demo Veri Modelleri
// ──────────────────────────────────────────
class TrendingProduct {
  final String name;
  final String price;
  final String imageEmoji; // Gerçek uygulamada URL olacak
  final String category;
  final int views;

  const TrendingProduct({
    required this.name,
    required this.price,
    required this.imageEmoji,
    required this.category,
    required this.views,
  });
}

class BrandData {
  final String name;
  final IconData icon;
  final List<TrendingProduct> products;

  const BrandData({required this.name, required this.icon, required this.products});
}

// ──────────────────────────────────────────
//  Demo Veriler
// ──────────────────────────────────────────
final List<BrandData> demoBrands = [
  BrandData(name: 'Zara', icon: Icons.storefront_rounded, products: [
    TrendingProduct(name: 'Oversize Blazer Ceket', price: '₺1.499', imageEmoji: '🧥', category: 'Dış Giyim', views: 12400),
    TrendingProduct(name: 'Wide Leg Jean', price: '₺899', imageEmoji: '👖', category: 'Alt Giyim', views: 9800),
    TrendingProduct(name: 'Saten Mini Elbise', price: '₺1.199', imageEmoji: '👗', category: 'Elbise', views: 8700),
    TrendingProduct(name: 'Deri Biker Ceket', price: '₺2.799', imageEmoji: '🧥', category: 'Dış Giyim', views: 7600),
    TrendingProduct(name: 'Crop Top Triko', price: '₺599', imageEmoji: '👚', category: 'Üst Giyim', views: 6500),
  ]),
  BrandData(name: 'H&M', icon: Icons.store_rounded, products: [
    TrendingProduct(name: 'Pamuklu Hoodie', price: '₺699', imageEmoji: '🧥', category: 'Üst Giyim', views: 15200),
    TrendingProduct(name: 'Slim Fit Chino', price: '₺499', imageEmoji: '👖', category: 'Alt Giyim', views: 11300),
    TrendingProduct(name: 'Oversized T-Shirt', price: '₺249', imageEmoji: '👕', category: 'Üst Giyim', views: 10100),
    TrendingProduct(name: 'Puffer Yelek', price: '₺899', imageEmoji: '🦺', category: 'Dış Giyim', views: 8900),
    TrendingProduct(name: 'Keten Gömlek', price: '₺449', imageEmoji: '👔', category: 'Üst Giyim', views: 7400),
  ]),
  BrandData(name: 'Bershka', icon: Icons.shopping_bag_rounded, products: [
    TrendingProduct(name: 'Cargo Pantolon', price: '₺799', imageEmoji: '👖', category: 'Alt Giyim', views: 13800),
    TrendingProduct(name: 'Baskılı Sweatshirt', price: '₺599', imageEmoji: '👕', category: 'Üst Giyim', views: 10500),
    TrendingProduct(name: 'Platform Ayakkabı', price: '₺1.099', imageEmoji: '👟', category: 'Ayakkabı', views: 9200),
    TrendingProduct(name: 'Denim Ceket', price: '₺1.299', imageEmoji: '🧥', category: 'Dış Giyim', views: 8100),
    TrendingProduct(name: 'Crop Triko Hırka', price: '₺549', imageEmoji: '🧶', category: 'Üst Giyim', views: 6800),
  ]),
  BrandData(name: 'Mango', icon: Icons.checkroom_rounded, products: [
    TrendingProduct(name: 'Yün Palto', price: '₺3.499', imageEmoji: '🧥', category: 'Dış Giyim', views: 11600),
    TrendingProduct(name: 'Pileli Midi Etek', price: '₺799', imageEmoji: '👗', category: 'Alt Giyim', views: 9400),
    TrendingProduct(name: 'İpek Bluz', price: '₺1.199', imageEmoji: '👚', category: 'Üst Giyim', views: 8700),
    TrendingProduct(name: 'Wide Leg Kumaş Pantolon', price: '₺999', imageEmoji: '👖', category: 'Alt Giyim', views: 7900),
    TrendingProduct(name: 'Trençkot', price: '₺2.999', imageEmoji: '🧥', category: 'Dış Giyim', views: 7200),
  ]),
  BrandData(name: 'Stradivarius', icon: Icons.dry_cleaning_rounded, products: [
    TrendingProduct(name: 'Jogger Pantolon', price: '₺549', imageEmoji: '👖', category: 'Alt Giyim', views: 14200),
    TrendingProduct(name: 'Baskılı Crop Top', price: '₺299', imageEmoji: '👚', category: 'Üst Giyim', views: 11800),
    TrendingProduct(name: 'Bomber Ceket', price: '₺1.199', imageEmoji: '🧥', category: 'Dış Giyim', views: 9500),
    TrendingProduct(name: 'Mom Fit Jean', price: '₺699', imageEmoji: '👖', category: 'Alt Giyim', views: 8800),
    TrendingProduct(name: 'Örme Elbise', price: '₺799', imageEmoji: '👗', category: 'Elbise', views: 7300),
  ]),
  BrandData(name: 'Trendyol', icon: Icons.local_mall_rounded, products: [
    TrendingProduct(name: 'Basic Tişört 3lü Set', price: '₺349', imageEmoji: '👕', category: 'Üst Giyim', views: 22500),
    TrendingProduct(name: 'Palazzo Pantolon', price: '₺399', imageEmoji: '👖', category: 'Alt Giyim', views: 18900),
    TrendingProduct(name: 'Puf Kol Bluz', price: '₺279', imageEmoji: '👚', category: 'Üst Giyim', views: 15600),
    TrendingProduct(name: 'Şişme Mont', price: '₺799', imageEmoji: '🧥', category: 'Dış Giyim', views: 12400),
    TrendingProduct(name: 'Suni Deri Pantolon', price: '₺449', imageEmoji: '👖', category: 'Alt Giyim', views: 10800),
  ]),
];

// ──────────────────────────────────────────
//  Marka Seçimi Ekranı
// ──────────────────────────────────────────
class SwipeBrandsScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  const SwipeBrandsScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = themeProvider.currentScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Keşfet')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Popüler Ürünleri Keşfet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
            const SizedBox(height: 6),
            Text('Bir marka seç, en çok ziyaret edilen ürünleri kaydırarak keşfet.',
                style: TextStyle(fontSize: 13, color: scheme.textSecondary)),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: demoBrands.length,
                itemBuilder: (context, index) {
                  final brand = demoBrands[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SwipeCardsScreen(
                          themeProvider: themeProvider,
                          brand: brand,
                        ),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: scheme.primary.withOpacity(0.1)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: scheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(brand.icon, color: scheme.primary, size: 24),
                          ),
                          const SizedBox(height: 10),
                          Text(brand.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.textPrimary)),
                          Text('${brand.products.length} ürün',
                              style: TextStyle(fontSize: 11, color: scheme.textSecondary)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  Swipe Kartları Ekranı
// ──────────────────────────────────────────
class SwipeCardsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final BrandData brand;
  const SwipeCardsScreen({Key? key, required this.themeProvider, required this.brand}) : super(key: key);

  @override
  State<SwipeCardsScreen> createState() => _SwipeCardsScreenState();
}

class _SwipeCardsScreenState extends State<SwipeCardsScreen> {
  int _currentIndex = 0;
  double _dragX = 0;
  double _dragY = 0;
  bool _isDragging = false;

  void _onPanStart(DragStartDetails details) {
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragX += details.delta.dx;
      _dragY += details.delta.dy;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final threshold = 100.0;

    if (_dragX.abs() > threshold) {
      // Sağa kaydırma = beğen, sola = geç
      final isLike = _dragX > 0;
      final scheme = widget.themeProvider.currentScheme;
      final product = widget.brand.products[_currentIndex];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLike ? '❤️ ${product.name} beğenildi!' : '⏭️ ${product.name} geçildi'),
          backgroundColor: isLike ? Colors.green : scheme.textSecondary,
          duration: const Duration(seconds: 1),
        ),
      );

      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.brand.products.length;
        _dragX = 0;
        _dragY = 0;
        _isDragging = false;
      });
    } else {
      setState(() {
        _dragX = 0;
        _dragY = 0;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.themeProvider.currentScheme;
    final products = widget.brand.products;

    if (products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.brand.name)),
        body: const Center(child: Text('Ürün bulunamadı.')),
      );
    }

    final product = products[_currentIndex];
    final angle = _dragX / 800;
    final opacity = (1 - (_dragX.abs() / 300)).clamp(0.5, 1.0);

    // Sağa: Yeşil, Sola: Kırmızı
    Color? overlayColor;
    String? overlayText;
    if (_dragX > 40) {
      overlayColor = Colors.green.withOpacity(0.2);
      overlayText = '❤️ TAKİP ET';
    } else if (_dragX < -40) {
      overlayColor = Colors.red.withOpacity(0.2);
      overlayText = '⏭️ GEÇ';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand.name),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('${_currentIndex + 1}/${products.length}',
                  style: TextStyle(fontSize: 14, color: scheme.textSecondary)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: AnimatedContainer(
                  duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    ..translate(_dragX, _dragY)
                    ..rotateZ(angle),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.55,
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: scheme.primary.withOpacity(0.15), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Emoji placeholder
                                Center(
                                  child: Container(
                                    width: 120, height: 120,
                                    decoration: BoxDecoration(
                                      color: scheme.primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Center(
                                      child: Text(product.imageEmoji, style: const TextStyle(fontSize: 56)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Kategori badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: scheme.accent.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(product.category,
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.accent)),
                                ),
                                const SizedBox(height: 12),
                                // Ürün adı
                                Text(product.name,
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: scheme.textPrimary)),
                                const SizedBox(height: 8),
                                // Fiyat
                                Text(product.price,
                                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: scheme.primary)),
                                const Spacer(),
                                // Ziyaret sayısı
                                Row(
                                  children: [
                                    Icon(Icons.visibility_outlined, size: 16, color: scheme.textSecondary),
                                    const SizedBox(width: 6),
                                    Text('${_formatViews(product.views)} görüntülenme',
                                        style: TextStyle(fontSize: 12, color: scheme.textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Overlay (sağ/sol kaydırmada)
                          if (overlayColor != null)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: overlayColor,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Center(
                                  child: Text(overlayText!,
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: scheme.textPrimary)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Alt butonlar
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.close_rounded, Colors.redAccent, scheme, () {
                  setState(() {
                    _currentIndex = (_currentIndex + 1) % products.length;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('⏭️ ${product.name} geçildi'), duration: const Duration(seconds: 1)),
                  );
                }),
                _actionButton(Icons.favorite_rounded, Colors.green, scheme, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❤️ ${product.name} beğenildi!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  setState(() {
                    _currentIndex = (_currentIndex + 1) % products.length;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, AppColorScheme scheme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64, height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}K';
    return views.toString();
  }
}
