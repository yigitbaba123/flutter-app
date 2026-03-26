import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class FavoriteBrand {
  final String name;
  final String domain;
  final IconData icon;
  bool isFavorite;

  FavoriteBrand({
    required this.name,
    required this.domain,
    required this.icon,
    this.isFavorite = false,
  });
}

class FavoriteBrandsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const FavoriteBrandsScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  State<FavoriteBrandsScreen> createState() => _FavoriteBrandsScreenState();
}

class _FavoriteBrandsScreenState extends State<FavoriteBrandsScreen> {
  final List<FavoriteBrand> _brands = [
    FavoriteBrand(name: 'Zara', domain: 'zara.com', icon: Icons.storefront_rounded),
    FavoriteBrand(name: 'H&M', domain: 'hm.com', icon: Icons.store_rounded),
    FavoriteBrand(name: 'Bershka', domain: 'bershka.com', icon: Icons.shopping_bag_rounded),
    FavoriteBrand(name: 'Mango', domain: 'mango.com', icon: Icons.checkroom_rounded),
    FavoriteBrand(name: 'Stradivarius', domain: 'stradivarius.com', icon: Icons.dry_cleaning_rounded),
    FavoriteBrand(name: 'Trendyol', domain: 'trendyol.com', icon: Icons.local_mall_rounded),
    FavoriteBrand(name: 'Lefties', domain: 'lefties.com', icon: Icons.style_rounded),
    FavoriteBrand(name: 'Pull&Bear', domain: 'pullandbear.com', icon: Icons.shopping_cart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = widget.themeProvider.currentScheme;
    final favorites = _brands.where((b) => b.isFavorite).toList();
    final others = _brands.where((b) => !b.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favori Markalar')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Hızlı Erişim',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
          const SizedBox(height: 6),
          Text('En çok takip ettiğin markaları favorilere ekle.',
              style: TextStyle(fontSize: 13, color: scheme.textSecondary)),
          const SizedBox(height: 24),

          // Favoriler
          if (favorites.isNotEmpty) ...[
            Text('⭐ Favorilerin',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.accent)),
            const SizedBox(height: 10),
            ...favorites.map((b) => _brandCard(b, scheme)),
            const SizedBox(height: 20),
          ],

          // Tüm Markalar
          Text('Tüm Markalar',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.textSecondary)),
          const SizedBox(height: 10),
          ...others.map((b) => _brandCard(b, scheme)),
        ],
      ),
    );
  }

  Widget _brandCard(FavoriteBrand brand, AppColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: brand.isFavorite
            ? scheme.primary.withOpacity(0.08)
            : scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: brand.isFavorite
            ? Border.all(color: scheme.primary.withOpacity(0.25), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(brand.icon, color: scheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brand.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.textPrimary)),
                Text(brand.domain,
                    style: TextStyle(fontSize: 12, color: scheme.textSecondary)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => brand.isFavorite = !brand.isFavorite),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: brand.isFavorite
                    ? Colors.amber.withOpacity(0.15)
                    : scheme.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                brand.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: brand.isFavorite ? Colors.amber : scheme.textSecondary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
