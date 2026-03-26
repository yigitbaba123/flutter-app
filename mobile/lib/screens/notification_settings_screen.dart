import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const NotificationSettingsScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _pushEnabled = true;
  String _selectedTone = 'Varsayılan';

  final List<String> _tones = ['Varsayılan', 'Özel Ses', 'Sessiz'];

  @override
  Widget build(BuildContext context) {
    final scheme = widget.themeProvider.currentScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Bildirim Ayarları')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Başlık
          Text('Stok Bildirimi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
          const SizedBox(height: 6),
          Text('Takip ettiğin ürün stoğa girdiğinde nasıl haberdar olmak istiyorsun?',
              style: TextStyle(fontSize: 13, color: scheme.textSecondary)),
          const SizedBox(height: 28),

          // Push Bildirim
          _buildToggleCard(
            scheme: scheme,
            icon: Icons.notifications_active_rounded,
            title: 'Push Bildirimi',
            subtitle: 'Ekranına anlık bildirim gelsin',
            value: _pushEnabled,
            onChanged: (v) => setState(() => _pushEnabled = v),
          ),
          const SizedBox(height: 12),

          // Sesli Bildirim
          _buildToggleCard(
            scheme: scheme,
            icon: Icons.volume_up_rounded,
            title: 'Sesli Bildirim',
            subtitle: 'Stok geldiğinde ses çalsın',
            value: _soundEnabled,
            onChanged: (v) => setState(() => _soundEnabled = v),
          ),
          const SizedBox(height: 12),

          // Titreşim
          _buildToggleCard(
            scheme: scheme,
            icon: Icons.vibration_rounded,
            title: 'Titreşim',
            subtitle: 'Telefon titresin',
            value: _vibrationEnabled,
            onChanged: (v) => setState(() => _vibrationEnabled = v),
          ),
          const SizedBox(height: 24),

          // Alarm Tonu
          Text('Alarm Tonu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: scheme.textPrimary)),
          const SizedBox(height: 12),
          ...List.generate(_tones.length, (i) {
            final tone = _tones[i];
            final isSelected = _selectedTone == tone;
            return GestureDetector(
              onTap: () => setState(() => _selectedTone = tone),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? scheme.primary.withOpacity(0.15) : scheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? scheme.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      tone == 'Sessiz' ? Icons.volume_off : Icons.music_note_rounded,
                      color: isSelected ? scheme.primary : scheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(tone,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? scheme.primary : scheme.textPrimary)),
                    const Spacer(),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded, color: scheme.primary, size: 20),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),
          // Info kartı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: scheme.accent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Özel ses dosyası yüklemek için "Özel Ses" seçeneğini seçtikten sonra cihazındaki ses dosyasını yükleyebilirsin.',
                    style: TextStyle(fontSize: 12, color: scheme.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard({
    required AppColorScheme scheme,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: scheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: scheme.textPrimary)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: scheme.primary,
          ),
        ],
      ),
    );
  }
}
