import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/character_provider.dart';
import 'package:myapp/providers/inventory_provider.dart';
import 'package:myapp/widgets/character_card.dart';
import 'package:myapp/widgets/paginated_grid.dart';
import 'package:myapp/models/inventory_item.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final theme = Theme.of(context);

    final ownedCharacters = inventoryProvider.ownedItems.where((item) => item.type == ItemType.character).toList();
    final ownedBackgrounds = inventoryProvider.ownedItems.where((item) => item.type == ItemType.background).toList();
    final ownedPotions = inventoryProvider.ownedItems.where((item) => item.type == ItemType.potion).toList();


    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                        height: 250, // Adjusted height to accommodate paginator
                        child: TabBarView(
                          children: [
                            PaginatedGrid<ShopItem>(
                              items: ownedCharacters,
                              itemBuilder: (item) {
                                final bool isSelected = characterProvider.selectedCharacter == item.assetPath;
                                return GestureDetector(
                                  onTap: () => characterProvider.updateCharacter(item.assetPath),
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
                                      child: Image.asset(item.assetPath, fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              },
                            ),
                            PaginatedGrid<ShopItem>(
                              items: ownedBackgrounds,
                              itemBuilder: (item) {
                                final bool isSelected = characterProvider.selectedBackground == item.assetPath;
                                return GestureDetector(
                                  onTap: () => characterProvider.updateBackground(item.assetPath),
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
                                      child: Image.asset(item.assetPath, fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              },
                            ),
                             if (ownedPotions.isEmpty)
                              Center(child: Text('Nenhuma poção no inventário.', style: theme.textTheme.bodyMedium))
                            else
                              PaginatedGrid<ShopItem>(
                                items: ownedPotions,
                                itemBuilder: (item) {
                                  return Card(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.asset(item.assetPath, fit: BoxFit.cover),
                                        ),
                                        Text(item.name),
                                      ],
                                    ),
                                  );
                                },
                              ),
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
