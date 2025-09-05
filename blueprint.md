# Visão Geral do Projeto

Este é um aplicativo gamificado de gerenciamento de hábitos, onde os usuários podem cuidar de um personagem virtual completando tarefas diárias. O aplicativo possui uma loja, inventário e um sistema de moedas e diamantes para compra de itens.

# Estilo e Design

- **Tema:** Modo escuro com toques de roxo e ciano.
- **Fonte:** Padrão do Flutter.
- **Componentes:**
  - **CharacterCard:** Exibe o personagem, seu status (HP, XP, MP) e as moedas/diamantes do usuário.
  - **PaginatedGrid:** Grade paginada para exibir itens no inventário e na loja.

# Recursos Implementados

- **Tela Inicial:** Exibe o `CharacterCard` e a lista de hábitos.
- **Tela de Inventário:**
  - Navegação por abas para Personagens, Fundos e Poções.
  - Exibe os itens que o usuário possui.
  - Permite ao usuário equipar diferentes personagens e fundos.
- **Tela da Loja:**
  - Layout consistente com as outras telas, com o `CharacterCard` no topo.
  - Navegação por abas para Personagens, Fundos e Poções.
  - Cards de itens com imagem, nome, preço (em moedas ou diamantes) e botão de compra.
  - Lógica para compra de itens, com feedback para o usuário.
- **Provedores (State Management):**
  - `CharacterProvider`: Gerencia o estado do personagem (personagem/fundo selecionado, posição).
  - `InventoryProvider`: Gerencia o inventário do usuário e a lógica de compra.
  - `HabitProvider`: Gerencia a lista de hábitos.
  - `ThemeProvider`: Gerencia o tema do aplicativo (claro/escuro).

# Plano de Alterações Atuais (Concluído)

1.  **Remover o título "Shop" da tela da Loja:** O título foi removido da `AppBar` para um visual mais limpo.
2.  **Adicionar o `CharacterCard` no topo da tela da Loja:** O card do personagem foi adicionado ao topo para consistência com as outras telas.
3.  **Ajustar o espaçamento do menu da Loja:** O espaçamento da `TabBar` e dos cards foi ajustado para um layout mais agradável.
4.  **Reestilizar os cards de itens da Loja:**
    - As imagens foram ajustadas para `BoxFit.contain` para evitar cortes.
    - A exibição do preço foi corrigida para mostrar apenas o ícone de diamante para itens que custam diamantes.
    - O problema de `overflow` nos cards foi resolvido ajustando a proporção (`childAspectRatio`) na `PaginatedGrid`.
5.  **Corrigir o espaçamento entre a `AppBar` e o `CharacterCard`:** A `AppBar` foi restaurada na tela da Loja para garantir um espaçamento consistente com as outras telas do aplicativo, resolvendo o problema de layout de forma definitiva.
