import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Stok bildirimi ses ve görsel bildirim yönetim servisi.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool pushEnabled = true;

  /// Stok bildirimi sesi çal
  Future<void> playStockAlert() async {
    if (!soundEnabled) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/stok_bildirim.mp3'));
    } catch (e) {
      debugPrint('Ses çalma hatası: $e');
    }
  }

  /// Ses önizlemesi (ayarlar ekranından test için)
  Future<void> playPreview() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/stok_bildirim.mp3'));
    } catch (e) {
      debugPrint('Ses önizleme hatası: $e');
    }
  }

  /// Sesi durdur
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  /// Stok geldi bildirimi (ses + snackbar)
  void showStockNotification(BuildContext context, String productName, String size) {
    // Sesi çal
    playStockAlert();

    // Görsel bildirim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎉 Stok Geldi!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('$productName · Beden: $size',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
