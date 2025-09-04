
import 'package:flutter/material.dart';

class IconPickerModal extends StatelessWidget {
  const IconPickerModal({super.key});

  // CORREÇÃO: Alterado de 'const' para 'final' para permitir a inicialização em tempo de execução.
  // As listas de ícones não são constantes de tempo de compilação.
  static final Map<String, List<IconData>> iconCategories = {
    'Saúde': [
      Icons.favorite,
      Icons.healing,
      Icons.local_hospital,
      Icons.medical_services,
      Icons.spa,
      Icons.fitness_center,
      Icons.self_improvement,
      // CORREÇÃO: O ícone 'ecg_heart_outlined' não existe. Substituído por 'monitor_heart'.
      Icons.monitor_heart,
    ],
    'Desenvolvimento': [
      Icons.psychology,
      Icons.lightbulb,
      Icons.school,
      Icons.book,
      Icons.cast_for_education,
      Icons.auto_stories,
      Icons.functions
    ],
    'Finanças': [
      Icons.attach_money,
      Icons.credit_card,
      Icons.savings,
      Icons.account_balance,
      Icons.trending_up,
      Icons.pie_chart,
      Icons.monetization_on
    ],
    'Trabalho': [
      Icons.work,
      Icons.business_center,
      Icons.laptop_mac,
      Icons.workspaces,
      Icons.apartment,
      Icons.domain_verification,
      Icons.groups
    ],
    'Lazer & Hobbies': [
      Icons.games,
      Icons.music_note,
      Icons.sports_esports,
      Icons.brush,
      Icons.palette,
      Icons.movie,
      Icons.photo_camera,
      Icons.flight_takeoff
    ],
    'Casa': [
      Icons.home,
      Icons.cleaning_services,
      Icons.kitchen,
      Icons.local_laundry_service,
      Icons.chair,
      Icons.bed,
      Icons.grass
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: iconCategories.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Escolha um Ícone', style: theme.textTheme.headlineSmall),
          ),
          TabBar(
            isScrollable: true,
            tabs: iconCategories.keys.map((title) => Tab(text: title)).toList(),
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.textTheme.bodySmall?.color,
          ),
          Expanded(
            child: TabBarView(
              children: iconCategories.entries.map((entry) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    final icon = entry.value[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(icon), // Retorna o ícone selecionado
                      borderRadius: BorderRadius.circular(50),
                      child: Icon(icon, size: 32, color: theme.colorScheme.onSurface),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
