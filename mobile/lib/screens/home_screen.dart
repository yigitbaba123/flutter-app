import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import 'theme_screen.dart';
import 'notification_settings_screen.dart';
import 'favorite_brands_screen.dart';
import 'price_history_screen.dart';
import 'swipe_cards_screen.dart';

// ──────────────────────────────────────────
//  Modeller
// ──────────────────────────────────────────
class TrackedItem {
  final String url;
  final String size;
  final String productName;
  bool inStock; // false = Stok Bekleniyor, true = Stokta

  TrackedItem(this.url, this.size, {this.productName = 'Ürün', this.inStock = false});
}

// ──────────────────────────────────────────
//  Arka Plan Dalga Animasyonu
// ──────────────────────────────────────────
class WaveBackground extends StatefulWidget {
  final AppColorScheme scheme;
  final Widget child;
  const WaveBackground({Key? key, required this.scheme, required this.child}) : super(key: key);

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        final t = _waveController.value;
        return Stack(
          children: [
            // Dalga 1
            Positioned(
              top: -120 + sin(t * 2 * pi) * 30,
              right: -80 + cos(t * 2 * pi) * 20,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.scheme.primary.withOpacity(0.25),
                      widget.scheme.primary.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Dalga 2
            Positioned(
              bottom: -60 + cos(t * 2 * pi + 1) * 25,
              left: -50 + sin(t * 2 * pi + 1) * 15,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.scheme.secondary.withOpacity(0.2),
                      widget.scheme.secondary.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Dalga 3
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4 + sin(t * 2 * pi + 2) * 20,
              left: MediaQuery.of(context).size.width * 0.5 + cos(t * 2 * pi + 2) * 30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.scheme.accent.withOpacity(0.15),
                      widget.scheme.accent.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
            widget.child,
          ],
        );
      },
    );
  }
}

// ──────────────────────────────────────────
//  Ana Ekran
// ──────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const HomeScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TrackedItem> _trackedItems = [];

  void _showAddProductModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return AddProductModal(
          themeProvider: widget.themeProvider,
          existingItems: _trackedItems,
          onAdd: (url, size, productName) {
            setState(() => _trackedItems.add(TrackedItem(url, size, productName: productName)));
          },
        );
      },
    );
  }

  void _showTrackedProducts() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TrackedProductsScreen(
        items: _trackedItems,
        themeProvider: widget.themeProvider,
        onChanged: () => setState(() {}),
      ),
    ));
  }

  void _openThemeSettings() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ThemeScreen(themeProvider: widget.themeProvider),
    ));
  }

  void _openNotificationSettings() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => NotificationSettingsScreen(themeProvider: widget.themeProvider),
    ));
  }

  void _openFavoriteBrands() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FavoriteBrandsScreen(themeProvider: widget.themeProvider),
    ));
  }

  void _openPriceHistory() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PriceHistoryScreen(themeProvider: widget.themeProvider),
    ));
  }

  void _openSwipeCards() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SwipeBrandsScreen(themeProvider: widget.themeProvider),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.themeProvider.currentScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('StockRadar',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: scheme.textPrimary)),
        actions: [
          IconButton(
            onPressed: _openThemeSettings,
            icon: Icon(Icons.palette_outlined, color: scheme.textSecondary),
            tooltip: 'Temalar',
          ),
        ],
      ),
      body: WaveBackground(
        scheme: scheme,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Hero kartı
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: scheme.surface.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: scheme.primary.withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('🔥 Stok Takip',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.accent)),
                      ),
                      const SizedBox(height: 16),
                      Text('Kaçırdığın Ürünleri\nYakalama Vakti.',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w900, height: 1.25,
                              letterSpacing: -0.5, color: scheme.textPrimary)),
                      const SizedBox(height: 12),
                      Text('Zara, H&M, Stradivarius ve daha fazlası...\nLinki yapıştır, beden stoğa girince bildirim al.',
                          style: TextStyle(fontSize: 14, color: scheme.textSecondary, height: 1.5)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildMainButton(
                  icon: Icons.add_alert_rounded,
                  label: 'Ürünün Stoğunu Takip Et',
                  color: scheme.primary,
                  textColor: scheme.textPrimary,
                  onTap: _showAddProductModal,
                ),
                const SizedBox(height: 14),
                _buildMainButton(
                  icon: Icons.inventory_2_outlined,
                  label: 'Takip Edilen Ürünler',
                  color: scheme.surface,
                  textColor: scheme.textPrimary,
                  onTap: _showTrackedProducts,
                  borderColor: scheme.primary.withOpacity(0.3),
                  badge: _trackedItems.isNotEmpty ? '${_trackedItems.length}' : null,
                  badgeColor: scheme.accent,
                ),
                const SizedBox(height: 24),
                // Alt menü butonları
                Row(
                  children: [
                    _buildSmallButton(Icons.notifications_outlined, 'Bildirimler', scheme, _openNotificationSettings),
                    const SizedBox(width: 10),
                    _buildSmallButton(Icons.star_outline_rounded, 'Favoriler', scheme, _openFavoriteBrands),
                    const SizedBox(width: 10),
                    _buildSmallButton(Icons.show_chart_rounded, 'Fiyat', scheme, _openPriceHistory),
                    const SizedBox(width: 10),
                    _buildSmallButton(Icons.style_rounded, 'Keşfet', scheme, _openSwipeCards),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Tema: ${scheme.name}',
                      style: TextStyle(fontSize: 12, color: scheme.textSecondary.withOpacity(0.5))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    Color? borderColor,
    String? badge,
    Color? badgeColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 14),
              Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor?.withOpacity(0.2) ?? Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badge,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: badgeColor ?? textColor)),
                ),
              if (badge == null)
                Icon(Icons.arrow_forward_ios_rounded, color: textColor.withOpacity(0.5), size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton(IconData icon, String label, AppColorScheme scheme, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: scheme.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.primary.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: scheme.textSecondary, size: 20),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  Çok Adımlı Ürün Ekleme Modalı
// ──────────────────────────────────────────
class AddProductModal extends StatefulWidget {
  final ThemeProvider themeProvider;
  final List<TrackedItem> existingItems;
  final Function(String, String, String) onAdd;
  const AddProductModal({
    Key? key,
    required this.onAdd,
    required this.themeProvider,
    required this.existingItems,
  }) : super(key: key);

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

enum _ModalStep { urlInput, sizeSelection, success, alreadyInStock, donomarEasterEgg }

class _AddProductModalState extends State<AddProductModal> {
  final TextEditingController _urlController = TextEditingController();
  _ModalStep _step = _ModalStep.urlInput;
  String? _selectedSize;
  String _previewName = '';
  String _previewSite = '';

  // Harfli ve sayılı bedenler
  final List<String> letterSizes = ['XS', 'S', 'M', 'L', 'XL', 'Donomar Size'];
  final List<String> numberSizes = ['30', '32', '34', '36', '38', '40'];

  void _onContinue() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    // Siteden ürün adı ve site ismi çıkar (basit parsing)
    _previewSite = _extractSiteName(url);
    _previewName = _extractProductName(url);

    setState(() => _step = _ModalStep.sizeSelection);
  }

  String _extractSiteName(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.replaceAll('www.', '');
      if (host.contains('zara')) return 'Zara';
      if (host.contains('hm.com') || host.contains('h&m')) return 'H&M';
      if (host.contains('bershka')) return 'Bershka';
      if (host.contains('mango')) return 'Mango';
      if (host.contains('stradivarius')) return 'Stradivarius';
      if (host.contains('trendyol')) return 'Trendyol';
      return host.split('.').first.toUpperCase();
    } catch (_) {
      return 'Web';
    }
  }

  String _extractProductName(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.isNotEmpty) {
        // URL'deki son anlamlı segmenti al
        var name = segments.last.replaceAll(RegExp(r'[-_]'), ' ').replaceAll(RegExp(r'\.html?'), '');
        if (name.length > 40) name = '${name.substring(0, 40)}...';
        return name;
      }
    } catch (_) {}
    return 'Ürün Detayı';
  }

  void _onSizeSelected(String size) {
    // Donomar Size easter egg
    if (size == 'Donomar Size') {
      setState(() {
        _selectedSize = size;
        _step = _ModalStep.donomarEasterEgg;
      });
      return;
    }

    // Zaten takip ediliyor mu kontrol et
    final alreadyTracked = widget.existingItems.any(
      (item) => item.url == _urlController.text.trim() && item.size == size,
    );

    // Simüle: rastgele %30 ihtimalle "zaten stokta" desin (gerçek API entegrasyonunda backend'den gelecek)
    final isCurrentlyInStock = Random().nextDouble() < 0.3;

    if (isCurrentlyInStock) {
      setState(() {
        _selectedSize = size;
        _step = _ModalStep.alreadyInStock;
      });
    } else {
      setState(() {
        _selectedSize = size;
      });
      widget.onAdd(_urlController.text.trim(), size, '$_previewSite · $_previewName');
      setState(() => _step = _ModalStep.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.themeProvider.currentScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: scheme.primary.withOpacity(0.1)),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tutma çubuğu
            Center(
              child: Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: scheme.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (_step == _ModalStep.urlInput) _buildUrlStep(scheme),
            if (_step == _ModalStep.sizeSelection) _buildSizeStep(scheme),
            if (_step == _ModalStep.success) _buildSuccessStep(scheme),
            if (_step == _ModalStep.alreadyInStock) _buildAlreadyInStockStep(scheme),
            if (_step == _ModalStep.donomarEasterEgg) _buildDonomarStep(scheme),
          ],
        ),
      ),
    );
  }

  // ─── Adım 1: URL Girişi ───
  Widget _buildUrlStep(AppColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Ürün Takibi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
        const SizedBox(height: 6),
        Text('Takip etmek istediğin ürünün linkini yapıştır.',
            style: TextStyle(fontSize: 13, color: scheme.textSecondary)),
        const SizedBox(height: 20),
        TextField(
          controller: _urlController,
          style: TextStyle(color: scheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'https://www.zara.com/...',
            prefixIcon: Icon(Icons.link, color: scheme.textSecondary),
            filled: true,
            fillColor: scheme.bg,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.textPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Devam Et', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  // ─── Adım 2: Ön İzleme + Beden Seçimi ───
  Widget _buildSizeStep(AppColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Preview kartı
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.primary.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              // Ürün resmi placeholder
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.checkroom_rounded, color: scheme.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_previewSite,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.accent)),
                    const SizedBox(height: 4),
                    Text(_previewName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Beden Seç', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
        const SizedBox(height: 6),
        Text('Takip etmek istediğin bedeni seç.',
            style: TextStyle(fontSize: 12, color: scheme.textSecondary)),
        const SizedBox(height: 14),
        // Harfli bedenler
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: letterSizes.map((s) => _sizeChip(s, scheme)).toList(),
        ),
        const SizedBox(height: 10),
        Divider(color: scheme.textSecondary.withOpacity(0.15)),
        const SizedBox(height: 10),
        // Sayılı bedenler
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: numberSizes.map((s) => _sizeChip(s, scheme)).toList(),
        ),
      ],
    );
  }

  // ─── Adım 3: Başarılı ───
  Widget _buildSuccessStep(AppColorScheme scheme) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.green, size: 36),
        ),
        const SizedBox(height: 20),
        Text('Başarıyla Takip Edildi!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
        const SizedBox(height: 8),
        Text('$_previewSite · Beden: $_selectedSize',
            style: TextStyle(fontSize: 14, color: scheme.textSecondary)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.textPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Tamam', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ─── Zaten Stokta Uyarısı ───
  Widget _buildAlreadyInStockStep(AppColorScheme scheme) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 36),
        ),
        const SizedBox(height: 20),
        Text('Bu Beden Zaten Stokta!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
        const SizedBox(height: 8),
        Text('$_previewSite · Beden: $_selectedSize\n\nBu bedeni şu anda satın alabilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: scheme.textSecondary, height: 1.5)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _step = _ModalStep.sizeSelection),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: scheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Başka Beden Seç', style: TextStyle(color: scheme.textPrimary, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Kapat', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  // ─── Donomar Size Easter Egg ───
  Widget _buildDonomarStep(AppColorScheme scheme) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.sentiment_very_dissatisfied_rounded, color: Colors.orange, size: 40),
        ),
        const SizedBox(height: 20),
        Text('Oha Bu Kadar Kilolu\nMusun Cidden?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: scheme.textPrimary, height: 1.3)),
        const SizedBox(height: 12),
        Text('😂 Şaka şaka, hemen takibe alalım...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: scheme.textSecondary)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _step = _ModalStep.sizeSelection),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: scheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Başka Beden', style: TextStyle(color: scheme.textPrimary, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onAdd(_urlController.text.trim(), 'Donomar Size', '$_previewSite · $_previewName');
                  setState(() => _step = _ModalStep.success);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Yine de Takip Et', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _sizeChip(String size, AppColorScheme scheme) {
    return GestureDetector(
      onTap: () => _onSizeSelected(size),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: size.length > 2 ? 14 : 18, vertical: 14),
        decoration: BoxDecoration(
          color: scheme.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.textSecondary.withOpacity(0.2), width: 1.5),
        ),
        child: Text(size,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: scheme.textPrimary)),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  Takip Edilen Ürünler Ekranı
// ──────────────────────────────────────────
class TrackedProductsScreen extends StatefulWidget {
  final List<TrackedItem> items;
  final ThemeProvider themeProvider;
  final VoidCallback onChanged;
  const TrackedProductsScreen({
    Key? key,
    required this.items,
    required this.themeProvider,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TrackedProductsScreen> createState() => _TrackedProductsScreenState();
}

class _TrackedProductsScreenState extends State<TrackedProductsScreen> {
  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        final scheme = widget.themeProvider.currentScheme;
        return AlertDialog(
          backgroundColor: scheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Takipten Çıkar', style: TextStyle(color: scheme.textPrimary)),
          content: Text('Bu ürünü takipten çıkarmak istediğine emin misin?',
              style: TextStyle(color: scheme.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('İptal', style: TextStyle(color: scheme.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                setState(() => widget.items.removeAt(index));
                widget.onChanged();
                Navigator.pop(ctx);
              },
              child: const Text('Çıkar', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.themeProvider.currentScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Takip Edilen Ürünler')),
      body: widget.items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_rounded, size: 56, color: scheme.textSecondary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text('Henüz takip edilen ürün yok.',
                      style: TextStyle(color: scheme.textSecondary, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Dismissible(
                  key: ValueKey('${item.url}_${item.size}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  ),
                  confirmDismiss: (_) async {
                    _removeItem(index);
                    return false;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: scheme.primary.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        // Beden ikonu
                        Container(
                          width: 46, height: 46,
                          decoration: BoxDecoration(
                            color: scheme.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(item.size,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: scheme.primary, fontSize: 13)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: scheme.textPrimary, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(item.url,
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: scheme.textSecondary, fontSize: 11)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Rozet: Stokta / Bekleniyor
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: item.inStock
                                ? Colors.green.withOpacity(0.15)
                                : Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.inStock ? 'Stokta' : 'Bekleniyor',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: item.inStock ? Colors.green : Colors.amber,
                            ),
                          ),
                        ),
                        // Sil butonu
                        IconButton(
                          onPressed: () => _removeItem(index),
                          icon: Icon(Icons.close, color: scheme.textSecondary.withOpacity(0.5), size: 18),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
