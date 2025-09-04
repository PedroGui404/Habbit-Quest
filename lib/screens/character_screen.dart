
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/character_provider.dart';
import 'package:myapp/widgets/character_card.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  // --- IMAGENS DISPONÍVEIS (Inventário da "loja") ---
  final List<String> characterImages = [
    'assets/images/characters/character_1_main.png',
    'assets/images/characters/character_2_police.png',
    'assets/images/characters/character_3_harrypotter.png',
    'assets/images/characters/character_4_cowboy.png',
    'assets/images/characters/character_5_robber.png',
  ];

  final List<String> backgroundImages = [
    'assets/images/backgrounds/background_1_grass.png',
    'assets/images/backgrounds/background_2_cave.png',
  ];

  // O estado local foi completamente removido daqui.

  @override
  Widget build(BuildContext context) {
    // 1. Conecta-se ao CharacterProvider para ler e modificar o estado.
    final characterProvider = Provider.of<CharacterProvider>(context);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 2. O CharacterCard agora lê os dados diretamente do provider.
              CharacterCard(
                backgroundImage: characterProvider.selectedBackground,
                characterImage: characterProvider.selectedCharacter,
                position: characterProvider.currentPosition,
              ),
              const SizedBox(height: 24),

              Card(
                color: theme.cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: theme.colorScheme.primary,
                        labelColor: theme.colorScheme.primary,
                        unselectedLabelColor: theme.textTheme.bodyLarge?.color?.withAlpha(178),
                        tabs: const [
                          Tab(text: 'Personagens'),
                          Tab(text: 'Fundos'),
                          Tab(text: 'Poções'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 150,
                        child: TabBarView(
                          children: [
                            // 3. Clicar em um item agora chama o provider para atualizar o estado global.
                            _buildInventoryGrid(
                              imagePaths: characterImages,
                              currentlySelectedPath: characterProvider.selectedCharacter,
                              onSelect: (path) => characterProvider.updateCharacter(path),
                            ),
                            _buildInventoryGrid(
                              imagePaths: backgroundImages,
                              currentlySelectedPath: characterProvider.selectedBackground,
                              onSelect: (path) => characterProvider.updateBackground(path),
                            ),
                            Center(child: Text('Nenhuma poção no inventário.', style: theme.textTheme.bodyMedium)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionCard(
                theme: theme,
                title: 'Melhorar Status',
                content: Column(
                  children: [
                    _buildStatusRow(theme, 'Força', 10),
                    _buildStatusRow(theme, 'Agilidade', 8),
                    _buildStatusRow(theme, 'Inteligência', 12),
                    const SizedBox(height: 10),
                    Text('Pontos disponíveis: 5', style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  _buildInfoCard(theme, 'Batalhas', '15'),
                  const SizedBox(width: 16),
                  _buildInfoCard(theme, 'Vitórias', '10'),
                   const SizedBox(width: 16),
                  _buildInfoCard(theme, 'Derrotas', '5'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. O grid agora recebe o item selecionado para destacar a borda corretamente.
  Widget _buildInventoryGrid({
    required List<String> imagePaths,
    required String currentlySelectedPath,
    required Function(String) onSelect,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10,
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        final path = imagePaths[index];
        final bool isSelected = currentlySelectedPath == path;
        return GestureDetector(
          onTap: () => onSelect(path),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.withAlpha(128),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(path, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  // Widgets auxiliares (sem alterações)
  Widget _buildSectionCard({required ThemeData theme, required String title, required Widget content}) {
    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            Divider(color: theme.dividerColor, height: 20),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(ThemeData theme, String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        Row(children: [
          Text(value.toString(), style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ]),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme, String title, String value) {
    return Expanded(
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Text(title, style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
