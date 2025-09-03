import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart'; // Import para acessar o ThemeProvider

// Modelos de dados simples para Hábitos e Tarefas
class Habit {
  String title;
  String subtitle;
  IconData icon;
  bool isDone;

  Habit({required this.title, required this.subtitle, required this.icon, this.isDone = false});
}

class Task {
  String title;
  String dueTime;
  bool isDone;

  Task({required this.title, required this.dueTime, this.isDone = false});
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Listas para gerenciar o estado dos hábitos e tarefas
  final List<Habit> _habits = [
    Habit(icon: Icons.water_drop, title: 'Beber 2L de água', subtitle: 'Saúde • Diário'),
    Habit(icon: Icons.book, title: 'Estudar Flutter por 30min', subtitle: 'Estudo • Seg a Sex'),
    Habit(icon: Icons.directions_run, title: 'Correr 5km na esteira', subtitle: 'Saúde • Diário'),
  ];

  final List<Task> _tasks = [
    Task(title: 'Reunião de alinhamento do projeto', dueTime: 'Hoje, 10:00'),
    Task(title: 'Entregar relatório de performance', dueTime: 'Hoje, 14:00'),
    Task(title: 'Ligar para o cliente X', dueTime: 'Hoje, 16:30', isDone: true),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    int completedHabits = _habits.where((h) => h.isDone).length;
    int completedTasks = _tasks.where((t) => t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            tooltip: 'Alternar Tema',
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(decoration: BoxDecoration(color: theme.primaryColor), child: Text('Menu', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white))),
            ListTile(title: const Text('Conquistas'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('Configurações'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('Logout'), onTap: () => Navigator.pop(context)),
            ListTile(title: const Text('Sobre'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Seção do Personagem ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset('assets/images/principal.png', height: 120, fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(height: 120, width: 90, color: Colors.grey[800], child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatusBars(),
                            const SizedBox(height: 12),
                            _buildCurrencyInfo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Cards de Resumo ---
              Row(
                children: [
                  Expanded(child: _buildSummaryCard('Hábitos', completedHabits, _habits.length, theme.primaryColor)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSummaryCard('Tarefas', completedTasks, _tasks.length, Colors.orange.shade600)),
                ],
              ),
              const SizedBox(height: 24),

              // --- Seção de Hábitos ---
              Text('Hábitos de Hoje', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              _buildHabitList(),
              const SizedBox(height: 24),

              // --- Seção de Tarefas ---
              Text('Tarefas de Hoje', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              _buildTaskList(),
            ],
          ),
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // --- WIDGETS DE CONSTRUÇÃO DA UI ---

  Widget _buildStatusBars() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusBar('HP', 80, Colors.red.shade400, '80/100'),
        const SizedBox(height: 8),
        _statusBar('XP', 60, Colors.green.shade400, '1200/2000'),
        const SizedBox(height: 8),
        _statusBar('MP', 90, Colors.blue.shade400, '90/100'),
      ],
    );
  }

  Widget _statusBar(String label, double value, Color color, String textValue) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $textValue', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: value / 100, backgroundColor: Colors.grey[800], valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 12),
        ),
      ],
    );
  }

  Widget _buildCurrencyInfo() {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.monetization_on, color: Colors.amber[600], size: 20),
        const SizedBox(width: 4),
        Text('150', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Icon(Icons.diamond_outlined, color: Colors.cyan[300], size: 20),
        const SizedBox(width: 4),
        Text('10', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryCard(String title, int completed, int total, Color indicatorColor) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '$completed', style: theme.textTheme.headlineSmall?.copyWith(color: indicatorColor, fontWeight: FontWeight.bold)),
                  TextSpan(text: ' / $total concluídos', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitList() {
    final theme = Theme.of(context);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _habits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = _habits[index];
        return InkWell(
          onTap: () => setState(() => habit.isDone = !habit.isDone),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: habit.isDone ? 0.5 : 1.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(habit.icon, color: habit.isDone ? Colors.grey : theme.primaryColor, size: 30),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, decoration: habit.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                        Text(habit.subtitle, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Icon(habit.isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: habit.isDone ? Colors.green : Colors.grey, size: 28),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskList() {
    final theme = Theme.of(context);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: task.isDone ? 0.5 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                      Text(task.dueTime, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Checkbox(
                  value: task.isDone,
                  onChanged: (bool? value) => setState(() => task.isDone = value ?? false),
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
