
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // 1. Importar o Provider
import 'package:table_calendar/table_calendar.dart';

import 'package:myapp/widgets/character_card.dart';
import 'package:myapp/widgets/add_task_modal.dart';
import 'package:myapp/providers/character_provider.dart'; // 2. Importar o CharacterProvider

// Modelos de dados e enums (sem alterações)
enum TaskPriority { alta, media, baixa }

class Task {
  String title;
  String description;
  DateTime dueDate;
  TimeOfDay dueTime;
  TaskPriority priority;
  bool isDone;

  Task({
    required this.title,
    this.description = '',
    required this.dueDate,
    required this.dueTime,
    this.priority = TaskPriority.media,
    this.isDone = false,
  });
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  // Estado do calendário e dados de exemplo (sem alterações)
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<Task> _allTasks = [
    Task(title: 'Reunião de Alinhamento', dueDate: DateTime.now(), dueTime: const TimeOfDay(hour: 10, minute: 0), priority: TaskPriority.alta),
    Task(title: 'Entregar Relatório', dueDate: DateTime.now(), dueTime: const TimeOfDay(hour: 14, minute: 30), priority: TaskPriority.media),
    Task(title: 'Consulta Médica', dueDate: DateTime.now().add(const Duration(days: 2)), dueTime: const TimeOfDay(hour: 11, minute: 0), priority: TaskPriority.alta, description: 'Levar exames'),
  ];

  late List<Task> _selectedTasks;

  List<Task> _getTasksForDay(DateTime day) {
    final dateOnly = DateTime.utc(day.year, day.month, day.day);
    return _allTasks.where((task) {
      final taskDateOnly = DateTime.utc(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      return isSameDay(taskDateOnly, dateOnly);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedTasks = _getTasksForDay(_selectedDay!);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedTasks = _getTasksForDay(selectedDay);
      });
    }
  }
  
  void _addTask(Task task) {
    setState(() {
      _allTasks.add(task);
      _selectedTasks = _getTasksForDay(_selectedDay!);
    });
  }

  void showAddTaskModal() {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => AddTaskModal(onTaskAdded: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 3. Conectar ao CharacterProvider
    final characterProvider = Provider.of<CharacterProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
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
            
            // O resto da tela permanece o mesmo
            _buildCalendar(theme), const SizedBox(height: 24),
            _buildSectionHeader(theme), const SizedBox(height: 12),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  // Widgets auxiliares (sem alterações)
  Widget _buildSectionHeader(ThemeData theme) {
    String title;
    if (isSameDay(_selectedDay, DateTime.now())) {
      title = 'Tarefas de Hoje';
    } else {
      title = 'Tarefas para ${DateFormat.yMd('pt_BR').format(_selectedDay!)}';
    }
    return Text(title, style: theme.textTheme.titleLarge);
  }

  Widget _buildCalendar(ThemeData theme) {
    return Card(
      elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar<Task>(
          locale: 'pt_BR', firstDay: DateTime.utc(2020, 1, 1), lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay, calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getTasksForDay,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(color: theme.primaryColor.withAlpha(128), shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
          ),
          headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false, titleTextStyle: theme.textTheme.titleMedium!),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                Color markerColor = events.length <= 2 ? Colors.green.shade400 : (events.length <= 4 ? Colors.orange.shade400 : Colors.red.shade400);
                return Positioned(bottom: 1, child: Container(width: 7.0, height: 7.0, decoration: BoxDecoration(shape: BoxShape.circle, color: markerColor)));
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    if (_selectedTasks.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Nenhuma tarefa para este dia.', style: TextStyle(fontSize: 16))));
    }
    _selectedTasks.sort((a, b) => a.dueTime.hour.compareTo(b.dueTime.hour));
    return ListView.separated(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedTasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = _selectedTasks[index];
        return TaskCard(task: task, onStatusChanged: () => setState(() => task.isDone = !task.isDone));
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onStatusChanged;

  const TaskCard({super.key, required this.task, required this.onStatusChanged});

  String _priorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.alta: return 'Alta';
      case TaskPriority.media: return 'Média';
      case TaskPriority.baixa: return 'Baixa';
    }
  }

  Color _priorityColor(TaskPriority priority, ThemeData theme) {
    switch (priority) {
      case TaskPriority.alta: return theme.brightness == Brightness.dark ? Colors.red.shade400 : Colors.red.shade700;
      case TaskPriority.media: return theme.brightness == Brightness.dark ? Colors.orange.shade400 : Colors.orange.shade700;
      case TaskPriority.baixa: return theme.brightness == Brightness.dark ? Colors.blue.shade400 : Colors.blue.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateTime = task.dueDate.add(Duration(hours: task.dueTime.hour, minutes: task.dueTime.minute));
    final isPast = !task.isDone && DateTime.now().isAfter(dateTime);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: task.isDone ? 0.6 : 1.0,
      child: Card(
        elevation: 2, 
        shape: RoundedRectangleBorder(
          side: BorderSide(color: isPast ? Colors.red.shade700 : Colors.transparent, width: 1.5),
          borderRadius: BorderRadius.circular(12)
        ),
        color: isPast ? (theme.brightness == Brightness.dark ? Colors.grey.shade900 : Colors.red.shade50) : theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              Checkbox(value: task.isDone, onChanged: (_) => onStatusChanged(), activeColor: Colors.green),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title, 
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, 
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                        color: isPast ? theme.colorScheme.error : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(task.description, style: theme.textTheme.bodyMedium)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: theme.textTheme.bodySmall?.color),
                        const SizedBox(width: 4),
                        Text(task.dueTime.format(context), style: theme.textTheme.bodySmall),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                          decoration: BoxDecoration(color: _priorityColor(task.priority, theme), borderRadius: BorderRadius.circular(8)), 
                          child: Text(_priorityText(task.priority), style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold))
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
