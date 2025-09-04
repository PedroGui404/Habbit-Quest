import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/data/shop_items.dart';
import 'package:myapp/models/inventory_item.dart';
import 'package:myapp/providers/character_provider.dart';
import 'package:myapp/providers/inventory_provider.dart';
import 'package:myapp/widgets/character_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _selectedCategoryIndex = 0;
  int _currentPage = 0;
  final int _itemsPerPage = 4;

  List<ShopItem> _getItemsForCategory(int index) {
    switch (index) {
      case 0:
        return shopItems.where((item) => item.type == ItemType.character).toList();
      case 1:
        return shopItems.where((item) => item.type == ItemType.background).toList();
      case 2:
        return shopItems.where((item) => item.type == ItemType.potion).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);
    final theme = Theme.of(context);

    final currentItems = _getItemsForCategory(_selectedCategoryIndex);
    final totalPages = (currentItems.length / _itemsPerPage).ceil();
    final paginatedItems = currentItems.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CharacterCard(
            backgroundImage: characterProvider.selectedBackground,
            characterImage: characterProvider.selectedCharacter,
            position: characterProvider.currentPosition,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 480, // Altura fixa para o card da loja
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  _buildNavigationMenu(theme),
                  const VerticalDivider(width: 1, thickness: 1),
                  _buildShopContent(theme, paginatedItems, totalPages),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu(ThemeData theme) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      color: theme.cardColor, // Garante consistência de cor
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _CategoryButton(
            icon: Icons.person_search_rounded,
            label: 'Personagens',
            isSelected: _selectedCategoryIndex == 0,
            onTap: () => setState(() {
              _selectedCategoryIndex = 0;
              _currentPage = 0;
            }),
          ),
          const SizedBox(height: 24),
          _CategoryButton(
            icon: Icons.landscape_rounded,
            label: 'Fundos',
            isSelected: _selectedCategoryIndex == 1,
            onTap: () => setState(() {
              _selectedCategoryIndex = 1;
              _currentPage = 0;
            }),
          ),
          const SizedBox(height: 24),
          _CategoryButton(
            icon: Icons.science_rounded,
            label: 'Poções',
            isSelected: _selectedCategoryIndex == 2,
            onTap: () => setState(() {
              _selectedCategoryIndex = 2;
              _currentPage = 0;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShopContent(ThemeData theme, List<ShopItem> items, int totalPages) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Text(
              'Loja',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text('Nenhum item disponível.', style: theme.textTheme.bodyMedium))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) => ShopItemCard(item: items[index]),
                    ),
            ),
            if (totalPages > 0)
              _buildPaginationControls(totalPages),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
        ),
        Text('Página ${_currentPage + 1} de $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
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

class ShopItemCard extends StatelessWidget {
  final ShopItem item;
  const ShopItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final isOwned = inventoryProvider.ownsItem(item);
    final theme = Theme.of(context);

    Widget priceWidget;
    if (item.priceDiamonds > 0) {
      priceWidget = Row(mainAxisSize: MainAxisSize.min, children: [ Icon(Icons.diamond_outlined, color: Colors.cyan.shade300, size: 16), const SizedBox(width: 4), Text(item.priceDiamonds.toString(), style: theme.textTheme.titleSmall) ]);
    } else {
      priceWidget = Row(mainAxisSize: MainAxisSize.min, children: [ Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 16), const SizedBox(width: 4), Text(item.priceCoins.toString(), style: theme.textTheme.titleSmall) ]);
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withAlpha(50),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset(item.assetPath, fit: BoxFit.contain))),
            Text(item.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            priceWidget,
            const SizedBox(height: 12),
            if (isOwned)
              const Chip(label: Text('Adquirido'), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.onPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                onPressed: () {
                  if (inventoryProvider.canAfford(item)) {
                    inventoryProvider.buyItem(item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recursos insuficientes.'), backgroundColor: Colors.red));
                  }
                },
                child: const Text('Comprar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}