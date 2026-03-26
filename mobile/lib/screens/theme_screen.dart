import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  const ThemeScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentScheme = themeProvider.currentScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Temalar')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Renk Şeması Seç',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Uygulama genelinde kullanılacak temayı buradan değiştirebilirsin.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                itemCount: AppThemes.all.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final scheme = AppThemes.all[index];
                  final isSelected = scheme.name == currentScheme.name;

                  return GestureDetector(
                    onTap: () {
                      themeProvider.setTheme(scheme);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? scheme.primary : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: scheme.primary.withOpacity(0.3), blurRadius: 12)]
                            : [],
                      ),
                      child: Row(
                        children: [
                          // Renk önizlemeleri
                          _colorDot(scheme.bg),
                          const SizedBox(width: 6),
                          _colorDot(scheme.primary),
                          const SizedBox(width: 6),
                          _colorDot(scheme.secondary),
                          const SizedBox(width: 6),
                          _colorDot(scheme.accent),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  scheme.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: scheme.textPrimary,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Aktif Tema',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle_rounded, color: scheme.primary, size: 28),
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

  Widget _colorDot(Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
      ),
    );
  }
}
