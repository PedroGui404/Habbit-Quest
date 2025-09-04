
enum ItemRarity { normal, raro, epico }
enum ItemType { character, background, potion }

class ShopItem {
  final String id;
  final String name;
  final String assetPath;
  final int priceCoins;
  final int priceDiamonds;
  final ItemRarity rarity;
  final ItemType type;
  final String description;

  ShopItem({
    required this.id,
    required this.name,
    required this.assetPath,
    this.priceCoins = 0,
    this.priceDiamonds = 0,
    required this.rarity,
    required this.type,
    required this.description,
  });
}

