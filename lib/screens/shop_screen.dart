import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:myapp/data/shop_items.dart';
import 'package:myapp/models/inventory_item.dart';
import 'package:myapp/providers/inventory_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
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

    final currentItems = _getItemsForCategory(_selectedCategoryIndex);
    final totalPages = (currentItems.length / _itemsPerPage).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const _VendorCard(),
          const SizedBox(height: 24),
          SizedBox(
            height: 575,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  _buildNavigationMenu(theme),
                  const VerticalDivider(width: 1, thickness: 1),
                  _buildShopContent(theme, currentItems, totalPages),
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
        color: theme.cardColor,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          _CategoryButton(icon: Icons.person_search_rounded, label: 'Personagens', isSelected: _selectedCategoryIndex == 0, onTap: () => _onCategorySelected(0)),
          const SizedBox(height: 24),
          _CategoryButton(icon: Icons.landscape_rounded, label: 'Fundos', isSelected: _selectedCategoryIndex == 1, onTap: () => _onCategorySelected(1)),
          const SizedBox(height: 24),
          _CategoryButton(icon: Icons.science_rounded, label: 'Poções', isSelected: _selectedCategoryIndex == 2, onTap: () => _onCategorySelected(2)),
        ]));
  }

  Widget _buildShopContent(ThemeData theme, List<ShopItem> items, int totalPages) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            Icon(Icons.storefront_outlined, color: Colors.amber, size: 40),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text('Nenhum item disponível.', style: theme.textTheme.bodyMedium))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: totalPages,
                      onPageChanged: (page) => setState(() => _currentPage = page),
                      itemBuilder: (context, pageIndex) {
                        final pageItems = items.skip(pageIndex * _itemsPerPage).take(_itemsPerPage).toList();
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
                          itemCount: pageItems.length,
                          itemBuilder: (context, itemIndex) => ShopItemCard(item: pageItems[itemIndex]),
                        );
                      },
                    ),
            ),
            if (totalPages > 1)
              _buildPageIndicator(totalPages, theme),
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

class _VendorCard extends StatefulWidget {
  const _VendorCard();

  @override
  State<_VendorCard> createState() => _VendorCardState();
}

class _VendorCardState extends State<_VendorCard> {
  late VideoPlayerController _controller;
  late String _randomQuote;

  final List<String> _vendorQuotes = [
    "Ah, um herói! E espero que traga ouro!",
    "Promoções imperdíveis... só que não!",
    "Gaste tudo, volte sempre!",
    "Nada como cheirar ouro pela manhã!",
    "Se for pagar com histórias, melhor que sejam boas.",
  ];

  @override
  void initState() {
    super.initState();
    _randomQuote = _vendorQuotes[Random().nextInt(_vendorQuotes.length)];

    _controller = VideoPlayerController.asset('assets/images/animations/vendedor1/vendedor1_idle.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inventory = Provider.of<InventoryProvider>(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seja bem vindo(a)!',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '— "$_randomQuote"'
                      , style: theme.textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: theme.textTheme.bodySmall?.color),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Row(children: [const Icon(Icons.monetization_on, color: Colors.amber, size: 20), const SizedBox(width: 4), Text(inventory.coins.toString(), style: theme.textTheme.titleLarge)])
                      , const SizedBox(width: 16),
Row(children: [const Icon(Icons.diamond_outlined, color: Colors.cyan, size: 20), const SizedBox(width: 4), Text(inventory.diamonds.toString(), style: theme.textTheme.titleLarge)])
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.card_giftcard_rounded),
                      label: const Text('Resgatar Prêmio Diário'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
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
        decoration: BoxDecoration(color: isSelected ? theme.colorScheme.primary.withAlpha(25) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [Icon(icon, color: color, size: 32), const SizedBox(height: 8), Text(label, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))]),
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
      priceWidget = Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.diamond_outlined, color: Colors.cyan, size: 16), const SizedBox(width: 4), Text(item.priceDiamonds.toString(), style: theme.textTheme.titleSmall)]);
    } else {
      priceWidget = Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.monetization_on, color: Colors.amber, size: 16), const SizedBox(width: 4), Text(item.priceCoins.toString(), style: theme.textTheme.titleSmall)]);
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black.withAlpha(50),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset(item.assetPath, fit: BoxFit.contain))),
          Text(item.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          priceWidget,
          const SizedBox(height: 8),
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
        ]),
      ),
    );
  }
}