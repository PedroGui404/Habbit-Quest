
import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Os dados ainda são estáticos, mas agora estão encapsulados neste widget.
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/principal.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120, width: 90,
                  color: Colors.grey[800],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBars(context),
                  const SizedBox(height: 12),
                  _buildCurrencyInfo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBars(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusBar(context, 'HP', 80, Colors.red.shade400, '80/100'),
        const SizedBox(height: 8),
        _statusBar(context, 'XP', 60, Colors.green.shade400, '1200/2000'),
        const SizedBox(height: 8),
        _statusBar(context, 'MP', 90, Colors.blue.shade400, '90/100'),
      ],
    );
  }

  Widget _statusBar(BuildContext context, String label, double value, Color color, String textValue) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $textValue', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: value / 100, backgroundColor: Colors.grey[800], valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 12),
        ),
      ],
    );
  }

  Widget _buildCurrencyInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.monetization_on, color: Colors.amber[600], size: 20),
        const SizedBox(width: 4),
        Text('150', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Icon(Icons.diamond_outlined, color: Colors.cyan[300], size: 20),
        const SizedBox(width: 4),
        Text('10', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
