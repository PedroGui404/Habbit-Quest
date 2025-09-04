import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/main.dart';
import 'package:myapp/screens/dashboard_screen.dart';
import 'package:myapp/screens/tasks_screen.dart';
import 'package:myapp/screens/habits_screen.dart';
import 'package:myapp/screens/character_screen.dart';
import 'package:myapp/screens/shop_screen.dart';

// Chaves para as telas que precisam de acesso externo
final GlobalKey<TasksScreenState> tasksScreenKey = GlobalKey<TasksScreenState>();
final GlobalKey<HabitsScreenState> habitsScreenKey = GlobalKey<HabitsScreenState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const DashboardScreen(),
      HabitsScreen(key: habitsScreenKey),
      TasksScreen(key: tasksScreenKey),
      const CharacterScreen(),
      const ShopScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar _buildAppBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    // Adicionando o título da Loja
    final List<String> titles = ['Dashboard', 'Hábitos', 'Tarefas', 'Personagem', 'Loja'];

    return AppBar(
      // Centralizando o título para consistência
      centerTitle: true,
      title: Text(titles[_selectedIndex], style: theme.textTheme.titleLarge),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        IconButton(
          icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          tooltip: 'Alternar Tema',
          onPressed: () => themeProvider.toggleTheme(),
        ),
      ],
    );
  }

  // Função para determinar qual ação o FAB deve executar
  VoidCallback? _getFabCallback() {
    if (_selectedIndex == 1) {
      return () => habitsScreenKey.currentState?.showAddHabitModal();
    } else if (_selectedIndex == 2) {
      return () => tasksScreenKey.currentState?.showAddTaskModal();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 110.0, 
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Menu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(title: const Text('Conquistas'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('Configurações'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('Logout'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('Sobre'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Hábitos'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Tarefas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Personagem'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Loja'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: _getFabCallback() != null
          ? FloatingActionButton(
              onPressed: _getFabCallback(),
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
