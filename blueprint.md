# Blueprint: App de Hábitos Gamificado

## Visão Geral

Este documento descreve o plano de desenvolvimento para um aplicativo de hábitos gamificado em Flutter. O objetivo é criar uma experiência de usuário envolvente e moderna, onde o progresso nos hábitos se reflete na evolução de um personagem virtual.

## Design e Estilo

- **Estética:** Moderna, limpa e responsiva, com foco em dispositivos móveis.
- **Cores:** Paleta de cores vibrantes e energéticas a ser definida.
- **Tipografia:** Uso do pacote `google_fonts` para uma aparência única e legível.
- **Componentes:** Utilização de componentes do Material 3 para um visual atualizado.
- **Ícones:** Ícones expressivos para facilitar a navegação e a compreensão.

## Funcionalidades Implementadas

*Esta seção será atualizada conforme o desenvolvimento avança.*

- **Versão Inicial:**
  - Estrutura básica do projeto Flutter.

## Plano Atual: Estrutura Inicial e Dashboard

O objetivo desta etapa é construir a fundação do aplicativo, incluindo a tela principal (Dashboard) e a navegação.

### Passos:

1.  **Configurar Dependências:**
    *   Adicionar `google_fonts` para tipografia personalizada.
    *   Adicionar `provider` para gerenciamento de estado (tema, dados do personagem).
    *   Adicionar `go_router` para uma navegação robusta e declarativa.

2.  **Estruturar o Projeto:**
    *   Modificar `lib/main.dart` para inicializar o app com um tema moderno.
    *   Criar um `ThemeProvider` para permitir a troca entre os modos claro e escuro.
    *   Configurar o `MaterialApp.router` com as rotas iniciais usando `go_router`.

3.  **Criar a Tela Principal (Dashboard):**
    *   Desenvolver um `Scaffold` principal que conterá:
        *   **AppBar:** Título e um ícone para abrir o Drawer.
        *   **BottomNavigationBar:** Com os itens: Home, Hábitos, Tarefas, Personagem e Loja.
        *   **Drawer:** Menu lateral com os itens: Conquistas, Configurações, Logout e Sobre.
        *   **FloatingActionButton:** Botão `+` para adicionar novos hábitos/tarefas.

4.  **Desenvolver o Layout do Dashboard:**
    *   **Seção do Personagem:**
        *   Exibir a imagem `principal.png`.
        *   Mostrar barras de status para HP, XP e MP.
    *   **Seção de Hábitos:**
        *   Criar uma lista de hábitos do dia (com dados de exemplo).
        *   Adicionar botões para marcar como concluído.
    *   **Seção de Resumo:**
        *   Exibir um resumo de hábitos pendentes e tarefas próximas.

5.  **Garantir Qualidade:**
    *   Formatar o código com `dart format .`.
    *   Verificar se há erros de análise com `flutter analyze`.
    *   Garantir que o aplicativo seja compilado e executado sem problemas.
