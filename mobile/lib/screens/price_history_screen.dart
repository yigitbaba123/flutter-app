import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class PriceHistoryScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  final String productName;
  final String currentPrice;

  const PriceHistoryScreen({
    Key? key,
    required this.themeProvider,
    this.productName = 'Ürün',
    this.currentPrice = '₺899',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = themeProvider.currentScheme;

    // Demo fiyat verileri
    final prices = _generateDemoPrices();
    final maxPrice = prices.reduce(max);
    final minPrice = prices.reduce(min);

    return Scaffold(
      appBar: AppBar(title: const Text('Fiyat Geçmişi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün bilgi kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(currentPrice,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: scheme.primary)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('▼ 12%',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Son 30 günlük fiyat grafiği',
                      style: TextStyle(fontSize: 12, color: scheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grafik
            Text('Fiyat Değişimi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomPaint(
                  painter: _PriceChartPainter(
                    prices: prices,
                    maxPrice: maxPrice,
                    minPrice: minPrice,
                    lineColor: scheme.primary,
                    fillColor: scheme.primary.withOpacity(0.1),
                    dotColor: scheme.accent,
                    gridColor: scheme.textSecondary.withOpacity(0.1),
                    textColor: scheme.textSecondary,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Min / Max kartları
            Row(
              children: [
                Expanded(child: _statCard('En Düşük', '₺${minPrice.toInt()}', Colors.green, scheme)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('En Yüksek', '₺${maxPrice.toInt()}', Colors.redAccent, scheme)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Ortalama', '₺${(prices.reduce((a, b) => a + b) / prices.length).toInt()}', scheme.accent, scheme)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, AppColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: scheme.textSecondary)),
        ],
      ),
    );
  }

  List<double> _generateDemoPrices() {
    final rng = Random(42); // Sabit seed = tutarlı demo veri
    double base = 899;
    return List.generate(30, (i) {
      base += (rng.nextDouble() - 0.45) * 40;
      if (base < 600) base = 620;
      if (base > 1200) base = 1150;
      return base;
    });
  }
}

// ──────────────────────────────────────────
//  Custom Painter — Mini Çizgi Grafik
// ──────────────────────────────────────────
class _PriceChartPainter extends CustomPainter {
  final List<double> prices;
  final double maxPrice;
  final double minPrice;
  final Color lineColor;
  final Color fillColor;
  final Color dotColor;
  final Color gridColor;
  final Color textColor;

  _PriceChartPainter({
    required this.prices,
    required this.maxPrice,
    required this.minPrice,
    required this.lineColor,
    required this.fillColor,
    required this.dotColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.isEmpty) return;

    final range = maxPrice - minPrice;
    final w = size.width;
    final h = size.height - 20; // Alt için yer
    final stepX = w / (prices.length - 1);

    // Grid çizgileri
    final gridPaint = Paint()..color = gridColor..strokeWidth = 0.5;
    for (int i = 0; i < 5; i++) {
      final y = h * i / 4;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Çizgi path
    final path = Path();
    final fillPath = Path();
    final points = <Offset>[];

    for (int i = 0; i < prices.length; i++) {
      final x = i * stepX;
      final y = h - ((prices[i] - minPrice) / range) * h;
      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, h);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(w, h);
    fillPath.close();

    // Fill
    canvas.drawPath(fillPath, Paint()..color = fillColor..style = PaintingStyle.fill);

    // Çizgi
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Son nokta vurgusu
    if (points.isNotEmpty) {
      final last = points.last;
      canvas.drawCircle(last, 5, Paint()..color = dotColor);
      canvas.drawCircle(last, 3, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
