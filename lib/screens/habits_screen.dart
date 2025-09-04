
import 'package:flutter/material.dart';
import 'package:myapp/widgets/character_card.dart';
import 'package:myapp/widgets/add_habit_modal.dart';

// Modelo para um Hábito
class Habit {
  final String title;
  final IconData icon;
  final String category;
  final FrequencyType frequencyType;
  final List<int> monthlyDays; // Dias do mês (1-31) se a frequência for mensal
  bool isCompletedToday;

  Habit({
    required this.title,
    required this.icon,
    required this.category,
    required this.frequencyType,
    this.monthlyDays = const [],
    this.isCompletedToday = false,
  });
}

enum FrequencyType { diario, mensal }

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  HabitsScreenState createState() => HabitsScreenState();
}

class HabitsScreenState extends State<HabitsScreen> {
  final List<Habit> _habits = [
    // Dados de exemplo
    Habit(title: 'Ler 10 páginas', icon: Icons.book, category: 'Desenvolvimento', frequencyType: FrequencyType.diario),
    Habit(title: 'Beber 2L de água', icon: Icons.local_drink, category: 'Saúde', frequencyType: FrequencyType.diario, isCompletedToday: true),
    Habit(title: 'Pagar fatura do cartão', icon: Icons.payment, category: 'Finanças', frequencyType: FrequencyType.mensal, monthlyDays: [15]),
    Habit(title: 'Revisão mensal do projeto', icon: Icons.work, category: 'Trabalho', frequencyType: FrequencyType.mensal, monthlyDays: [1, 15, 30]),
  ];

  void showAddHabitModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddHabitModal(onHabitAdded: _addHabit),
    );
  }

  void _addHabit(Habit habit) {
    setState(() {
      _habits.add(habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dailyHabits = _habits.where((h) => h.frequencyType == FrequencyType.diario).toList();
    final monthlyHabits = _habits.where((h) => h.frequencyType == FrequencyType.mensal).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CharacterCard(),
            const SizedBox(height: 24),

            // Seção de Hábitos Diários
            if (dailyHabits.isNotEmpty) ...[
              Text('Hábitos Diários', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dailyHabits.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return HabitCard(habit: dailyHabits[index]);
                },
              ),
              const SizedBox(height: 24),
            ],

            // Seção de Hábitos Mensais
            if (monthlyHabits.isNotEmpty) ...[
              Text('Hábitos Mensais', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: monthlyHabits.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return HabitCard(habit: monthlyHabits[index]);
                },
              ),
            ],
            
            if (dailyHabits.isEmpty && monthlyHabits.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Nenhum hábito cadastrado ainda.\nClique no botão + para começar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Widget para o Card de Hábito
class HabitCard extends StatefulWidget {
  final Habit habit;
  const HabitCard({super.key, required this.habit});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.habit.isCompletedToday = !widget.habit.isCompletedToday;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                widget.habit.icon,
                color: widget.habit.isCompletedToday ? Colors.green : theme.colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habit.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: widget.habit.isCompletedToday ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (widget.habit.frequencyType == FrequencyType.mensal)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Dias: ${widget.habit.monthlyDays.join(', ')}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.habit.isCompletedToday)
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
