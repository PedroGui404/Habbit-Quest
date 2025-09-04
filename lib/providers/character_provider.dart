
import 'package:flutter/material.dart';
import 'package:myapp/widgets/character_card.dart'; // Precisamos da definição de CharacterPosition

class CharacterProvider with ChangeNotifier {
  // --- ESTADO PRIVADO ---
  // Valores iniciais para o personagem e fundo
  String _selectedCharacter = 'assets/images/characters/character_1_main.png';
  String _selectedBackground = 'assets/images/backgrounds/background_1_grass.png';

  // O mapa de posições que antes estava na tela, agora fica aqui.
  final Map<String, CharacterPosition> _characterPositions = {
    'assets/images/backgrounds/background_1_grass.png': const CharacterPosition(
      width: 120, height: 120, bottom: 17
    ),
    'assets/images/backgrounds/background_2_cave.png': const CharacterPosition(
      width: 120, height: 120, bottom: -10
    ),
  };

  // --- GETTERS PÚBLICOS ---
  // Qualquer widget no app pode ler estes valores.
  String get selectedCharacter => _selectedCharacter;
  String get selectedBackground => _selectedBackground;
  
  // Getter que já retorna a posição correta para o fundo atual.
  CharacterPosition get currentPosition {
    // Usa a posição do mapa ou um valor padrão que centraliza o personagem.
    return _characterPositions[_selectedBackground] ?? 
           const CharacterPosition(width: 120, height: 120);
  }

  // --- MÉTODOS PÚBLICOS PARA MODIFICAR O ESTADO ---

  // Chamado quando o usuário seleciona um novo personagem.
  void updateCharacter(String newCharacterPath) {
    if (_selectedCharacter != newCharacterPath) {
      _selectedCharacter = newCharacterPath;
      notifyListeners(); // Notifica todos os widgets que estão ouvindo para se reconstruírem.
    }
  }

  // Chamado quando o usuário seleciona um novo fundo.
  void updateBackground(String newBackgroundPath) {
    if (_selectedBackground != newBackgroundPath) {
      _selectedBackground = newBackgroundPath;
      notifyListeners(); // Notifica todos os widgets que estão ouvindo para se reconstruírem.
    }
  }
}
