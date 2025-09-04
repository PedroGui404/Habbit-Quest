
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Importar o Provider
import 'package:myapp/widgets/character_card.dart'; 
import 'package:myapp/providers/character_provider.dart'; // 2. Importar o CharacterProvider

// Modelos de dados (mantidos para o conteúdo do dashboard)
class Habit {
  String title, subtitle;
  IconData icon;
  bool isDone;
  Habit({required this.title, required this.subtitle, required this.icon, this.isDone = false});
}

class Task {
  String title, dueTime;
  bool isDone;
  Task({required this.title, required this.dueTime, this.isDone = false});
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Dados de exemplo para o dashboard
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 3. Conectar ao CharacterProvider para ler os dados do personagem
    final characterProvider = Provider.of<CharacterProvider>(context);

    int completedHabits = _habits.where((h) => h.isDone).length;
    int completedTasks = _tasks.where((t) => t.isDone).length;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4. O CharacterCard agora usa os dados do provider
            CharacterCard(
              backgroundImage: characterProvider.selectedBackground,
              characterImage: characterProvider.selectedCharacter,
              position: characterProvider.currentPosition,
            ),
            const SizedBox(height: 24),

            // --- O resto do dashboard permanece o mesmo ---
            Row(
              children: [
                Expanded(child: _buildSummaryCard('Hábitos', completedHabits, _habits.length, theme.primaryColor)),
                const SizedBox(width: 16),
                Expanded(child: _buildSummaryCard('Tarefas', completedTasks, _tasks.length, Colors.orange.shade600)),
              ],
            ),
            const SizedBox(height: 24),

            Text('Hábitos de Hoje', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildHabitList(),
            const SizedBox(height: 24),

            Text('Tarefas de Hoje', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  // --- Widgets auxiliares (sem alterações) ---

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
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(habit.icon, color: habit.isDone ? Colors.grey : Theme.of(context).primaryColor, size: 30),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit.title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, decoration: habit.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                        Text(habit.subtitle, style: Theme.of(context).textTheme.bodyMedium),
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
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                      Text(task.dueTime, style: Theme.of(context).textTheme.bodyMedium),
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
