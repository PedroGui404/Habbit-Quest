
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/screens/tasks_screen.dart'; // Para o enum Task e TaskPriority

class AddTaskModal extends StatefulWidget {
  final Function(Task) onTaskAdded;

  const AddTaskModal({super.key, required this.onTaskAdded});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskPriority _selectedPriority = TaskPriority.media;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020), lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione data e hora.')),
        );
        return;
      }

      final newTask = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDate!,
        dueTime: _selectedTime!,
        priority: _selectedPriority,
      );
      widget.onTaskAdded(newTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Adicionar Nova Tarefa', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'O título é obrigatório' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição (Opcional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Data', border: OutlineInputBorder()),
                        child: Text(_selectedDate == null ? 'Selecionar Data' : DateFormat.yMd('pt_BR').format(_selectedDate!)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Hora', border: OutlineInputBorder()),
                        child: Text(_selectedTime == null ? 'Selecionar Hora' : _selectedTime!.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<TaskPriority>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Prioridade', border: OutlineInputBorder()),
                items: TaskPriority.values.map((priority) {
                  final priorityName = priority.toString().split('.').last;
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(priorityName[0].toUpperCase() + priorityName.substring(1)), // CORREÇÃO APLICADA
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPriority = value!),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _submitForm, child: const Text('Salvar Tarefa')),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
