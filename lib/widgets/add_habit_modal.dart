
import 'package:flutter/material.dart';
import 'package:myapp/screens/habits_screen.dart';
import 'package:myapp/widgets/icon_picker_modal.dart';

class AddHabitModal extends StatefulWidget {
  final Function(Habit) onHabitAdded;

  const AddHabitModal({super.key, required this.onHabitAdded});

  @override
  State<AddHabitModal> createState() => _AddHabitModalState();
}

class _AddHabitModalState extends State<AddHabitModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  IconData _selectedIcon = Icons.star; // Ícone padrão
  String _selectedCategory = 'Saúde'; // Categoria padrão
  FrequencyType _selectedFrequency = FrequencyType.diario;
  final List<int> _selectedMonthlyDays = [];

  final List<String> _categories = ['Saúde', 'Desenvolvimento', 'Finanças', 'Trabalho', 'Lazer'];

  void _showIconPicker() async {
    final IconData? pickedIcon = await showModalBottomSheet(
      context: context,
      builder: (ctx) => const IconPickerModal(),
    );
    if (pickedIcon != null) {
      setState(() {
        _selectedIcon = pickedIcon;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFrequency == FrequencyType.mensal && _selectedMonthlyDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione pelo menos um dia para a frequência mensal.')),
        );
        return;
      }

      final newHabit = Habit(
        title: _titleController.text,
        icon: _selectedIcon,
        category: _selectedCategory,
        frequencyType: _selectedFrequency,
        monthlyDays: _selectedFrequency == FrequencyType.mensal ? _selectedMonthlyDays : [],
      );
      widget.onHabitAdded(newHabit);
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
              Text('Adicionar Novo Hábito', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'O título é obrigatório' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
                      items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: _showIconPicker,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                      child: Icon(_selectedIcon, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Frequência', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ToggleButtons(
                isSelected: [_selectedFrequency == FrequencyType.diario, _selectedFrequency == FrequencyType.mensal],
                onPressed: (index) {
                  setState(() {
                    _selectedFrequency = index == 0 ? FrequencyType.diario : FrequencyType.mensal;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Diário')), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Mensal'))],
              ),
              if (_selectedFrequency == FrequencyType.mensal) ...[
                const SizedBox(height: 16),
                _buildMonthlyDaySelector(),
              ],
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submitForm, child: const Text('Salvar Hábito'))),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selecione os dias do mês:', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: List.generate(31, (index) {
            final day = index + 1;
            final isSelected = _selectedMonthlyDays.contains(day);
            return ChoiceChip(
              label: Text(day.toString()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedMonthlyDays.add(day);
                  } else {
                    _selectedMonthlyDays.remove(day);
                  }
                  _selectedMonthlyDays.sort();
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
