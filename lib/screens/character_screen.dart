import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/models/inventory_item.dart';
import 'package:myapp/providers/character_provider.dart';
import 'package:myapp/providers/inventory_provider.dart';
import 'package:myapp/widgets/character_card.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
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
            const _InventoryCard(),
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
    );
  }

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

class _InventoryCard extends StatefulWidget {
  const _InventoryCard();

  @override
  State<_InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<_InventoryCard> {
  int _selectedCategoryIndex = 0;
  int _currentPage = 0;
  final int _itemsPerPage = 4;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<ShopItem> _getItemsForCategory(InventoryProvider inventory, int index) {
    final items = inventory.ownedItems;
    switch (index) {
      case 0:
        return items.where((item) => item.type == ItemType.character).toList();
      case 1:
        return items.where((item) => item.type == ItemType.background).toList();
      case 2:
        return items.where((item) => item.type == ItemType.potion).toList();
      default:
        return [];
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final characterProvider = Provider.of<CharacterProvider>(context);

    final currentItems = _getItemsForCategory(inventoryProvider, _selectedCategoryIndex);
    final totalPages = (currentItems.length / _itemsPerPage).ceil();

    return SizedBox(
      height: 480, // Increased height to fit 4 items
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _buildNavigationMenu(theme),
            const VerticalDivider(width: 1, thickness: 1),
            _buildInventoryContent(theme, characterProvider, currentItems, totalPages),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationMenu(ThemeData theme) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      color: theme.cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _CategoryButton(icon: Icons.person, label: 'Personagens', isSelected: _selectedCategoryIndex == 0, onTap: () => _onCategorySelected(0)),
          const SizedBox(height: 24),
          _CategoryButton(icon: Icons.landscape, label: 'Fundos', isSelected: _selectedCategoryIndex == 1, onTap: () => _onCategorySelected(1)),
          const SizedBox(height: 24),
          _CategoryButton(icon: Icons.science, label: 'Poções', isSelected: _selectedCategoryIndex == 2, onTap: () => _onCategorySelected(2)),
        ],
      ),
    );
  }

  Widget _buildInventoryContent(ThemeData theme, CharacterProvider characterProvider, List<ShopItem> items, int totalPages) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, color: Colors.brown, size: 40),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text('Nenhum item nesta categoria.', style: theme.textTheme.bodyMedium))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: totalPages,
                      onPageChanged: (page) => setState(() => _currentPage = page),
                      itemBuilder: (context, pageIndex) {
                        final pageItems = items.skip(pageIndex * _itemsPerPage).take(_itemsPerPage).toList();
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1, // Adjusted for better square-like items
                          ),
                          itemCount: pageItems.length,
                          itemBuilder: (context, itemIndex) {
                            final item = pageItems[itemIndex];
                            bool isSelected = false;
                            VoidCallback? onTapAction;

                            if (item.type == ItemType.character) {
                              isSelected = characterProvider.selectedCharacter == item.assetPath;
                              onTapAction = () => characterProvider.updateCharacter(item.assetPath);
                            } else if (item.type == ItemType.background) {
                              isSelected = characterProvider.selectedBackground == item.assetPath;
                              onTapAction = () => characterProvider.updateBackground(item.assetPath);
                            }

                            return _InventoryItemCard(item: item, isSelected: isSelected, onTap: onTapAction);
                          },
                        );
                      },
                    ),
            ),
            if (totalPages > 1) _buildPageIndicator(totalPages, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int totalPages, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? theme.colorScheme.primary : Colors.grey.shade400,
          ),
        );
      }),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.colorScheme.primary : theme.unselectedWidgetColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  final ShopItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _InventoryItemCard({required this.item, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 3),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(item.assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}