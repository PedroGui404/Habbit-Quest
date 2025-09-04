import 'package:myapp/models/inventory_item.dart';

final List<ShopItem> shopItems = [
  ShopItem(
    id: 'character_2_police',
    name: 'Police',
    assetPath: 'assets/images/characters/character_2_police.png',
    priceCoins: 500,
    rarity: ItemRarity.raro,
    type: ItemType.character,
    description: 'A police officer character.'
  ),
  ShopItem(
    id: 'character_3_harrypotter',
    name: 'Wizard',
    assetPath: 'assets/images/characters/character_3_harrypotter.png',
    priceCoins: 1000,
    priceDiamonds: 10,
    rarity: ItemRarity.epico,
    type: ItemType.character,
    description: 'A wizard character.'
  ),
  ShopItem(
    id: 'character_4_cowboy',
    name: 'Cowboy',
    assetPath: 'assets/images/characters/character_4_cowboy.png',
    priceCoins: 300,
    rarity: ItemRarity.normal,
    type: ItemType.character,
    description: 'A cowboy character.'
  ),
  ShopItem(
    id: 'character_5_robber',
    name: 'Robber',
    assetPath: 'assets/images/characters/character_5_robber.png',
    priceCoins: 300,
    rarity: ItemRarity.normal,
    type: ItemType.character,
    description: 'A robber character.'
  ),
  ShopItem(
    id: 'background_2_cave',
    name: 'Cave',
    assetPath: 'assets/images/backgrounds/background_2_cave.png',
    priceCoins: 200,
    rarity: ItemRarity.raro,
    type: ItemType.background,
    description: 'A cave background.'
  ),
  ShopItem(
      id: 'potion_1',
      name: 'Health Potion',
      assetPath: 'assets/images/potions/potion_1.png',
      priceCoins: 50,
      rarity: ItemRarity.normal,
      type: ItemType.potion,
      description: 'Restores 10 health.'
  ),
  ShopItem(
      id: 'potion_2',
      name: 'Mana Potion',
      assetPath: 'assets/images/potions/potion_2.png',
      priceCoins: 50,
      rarity: ItemRarity.normal,
      type: ItemType.potion,
      description: 'Restores 10 mana.'
  ),
];
