
import 'package:flutter/material.dart';
import 'package:myapp/models/inventory_item.dart';

class InventoryProvider with ChangeNotifier {
  int _coins = 1000;
  int _diamonds = 50;
  final List<ShopItem> _ownedItems = [];

  int get coins => _coins;
  int get diamonds => _diamonds;
  List<ShopItem> get ownedItems => _ownedItems;

  InventoryProvider() {
    _ownedItems.add(ShopItem(
      id: 'character_1_main',
      name: 'Main Character',
      assetPath: 'assets/images/characters/character_1_main.png',
      rarity: ItemRarity.normal,
      type: ItemType.character,
      description: 'The main character.'
    ));
    _ownedItems.add(ShopItem(
        id: 'background_1_grass',
        name: 'Grass Background',
        assetPath: 'assets/images/backgrounds/background_1_grass.png',
        rarity: ItemRarity.normal,
        type: ItemType.background,
        description: 'A grassy background.'
    ));
  }

  bool canAfford(ShopItem item) {
    return _coins >= item.priceCoins && _diamonds >= item.priceDiamonds;
  }

  void buyItem(ShopItem item) {
    if (canAfford(item)) {
      _coins -= item.priceCoins;
      _diamonds -= item.priceDiamonds;
      _ownedItems.add(item);
      notifyListeners();
    }
  }

  bool ownsItem(ShopItem item) {
    return _ownedItems.any((ownedItem) => ownedItem.id == item.id);
  }
}
