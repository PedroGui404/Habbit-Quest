
import 'package:flutter/material.dart';

// Definição para posicionamento customizado do personagem
class CharacterPosition {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double width;
  final double height;

  const CharacterPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.width,
    required this.height,
  });

  // Verifica se uma posição explícita foi fornecida
  bool get isPositioned => top != null || bottom != null || left != null || right != null;
}

class CharacterCard extends StatelessWidget {
  final String backgroundImage;
  final String characterImage;
  final CharacterPosition position;

  const CharacterCard({
    super.key,
    required this.backgroundImage,
    required this.characterImage,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: theme.colorScheme.surface, // Cor de fundo do card
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Lado Esquerdo: Imagem
            _buildCharacterImage(theme),
            // Lado Direito: Informações
            _buildStatsInfo(context),
          ],
        ),
      ),
    );
  }

  // Widget para a imagem do personagem e fundo
  Widget _buildCharacterImage(ThemeData theme) {
    return SizedBox(
      width: 150,
      height: 150, // Altura fixa para a imagem
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Imagem de Fundo
          Image.asset(
            backgroundImage,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: theme.colorScheme.onSurface.withAlpha(26),
              child: const Center(child: Icon(Icons.error_outline, color: Colors.grey)),
            ),
          ),
          // 2. Imagem do Personagem
          // Usa Positioned se uma posição for especificada, senão centraliza
          position.isPositioned
              ? Positioned(
                  top: position.top,
                  left: position.left,
                  bottom: position.bottom,
                  right: position.right,
                  child: _characterImageAsset(),
                )
              : Center(
                  child: _characterImageAsset(),
                ),
        ],
      ),
    );
  }
  
  // Helper para a imagem do personagem para evitar repetição
  Widget _characterImageAsset() {
    return Image.asset(
      characterImage,
      width: position.width,
      height: position.height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: position.width,
        height: position.height,
        child: const Center(child: Icon(Icons.person_off_outlined, color: Colors.grey, size: 50)),
      ),
    );
  }

  // Widget para as informações de status e moedas
  Widget _buildStatsInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBars(context),
            const Spacer(), // Empurra as moedas para o fundo
            _buildCurrencyInfo(context),
          ],
        ),
      ),
    );
  }

  // As barras de status (HP, XP, MP)
  Widget _buildStatusBars(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusBar(context, 'HP', 80, Colors.red.shade400, '80/100'),
        const SizedBox(height: 10),
        _statusBar(context, 'XP', 60, Colors.green.shade400, '1200/2000'),
        const SizedBox(height: 10),
        _statusBar(context, 'MP', 90, Colors.blue.shade400, '90/100'),
      ],
    );
  }

  Widget _statusBar(BuildContext context, String label, double value, Color color, String textValue) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $textValue',
          style: textStyle,
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: theme.colorScheme.onSurface.withAlpha(26),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  // Informações de moeda
  Widget _buildCurrencyInfo(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.monetization_on, color: Colors.amber[700], size: 22),
        const SizedBox(width: 4),
        Text('150', style: textStyle),
        const SizedBox(width: 20),
        Icon(Icons.diamond_outlined, color: Colors.cyan[400], size: 22),
        const SizedBox(width: 4),
        Text('10', style: textStyle),
      ],
    );
  }
}
