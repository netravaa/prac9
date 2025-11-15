import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/recipes/widgets/recipe_tile.dart';
import 'package:prac5/features/recipes/bloc/recipes_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценки'),
      ),
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          if (state is RecipesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! RecipesLoaded) {
            return const Center(child: Text('Нет данных'));
          }

          // Берём только рецепты с выставленной оценкой
          final rated = state.recipes
              .where((r) => r.rating != null)
              .toList()
            ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

          if (rated.isEmpty) {
            return const EmptyState(
              icon: Icons.star_outline,
              title: 'Пока нет оценок',
              subtitle: 'Оцените несколько рецептов — они появятся здесь',
            );
          }

          final double avg = rated
                  .map((r) => r.rating ?? 0)
                  .fold<double>(0, (a, b) => a + b) /
              rated.length;

          return Column(
            children: [
              // Статистика
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.star,
                        iconColor: Colors.amber,
                        value: avg.toStringAsFixed(1),
                        label: 'Средняя оценка',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.amber.withOpacity(0.25),
                    ),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.check_circle,
                        iconColor: theme.colorScheme.primary,
                        value: rated.length.toString(),
                        label: 'Оценено рецептов',
                      ),
                    ),
                  ],
                ),
              ),

              // Список оценённых рецептов
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: rated.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final recipe = rated[index];
                    return RecipeTile(
                      key: ValueKey(recipe.id),
                      recipe: recipe,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textMuted = Colors.grey.shade600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: textMuted,
          ),
        ),
      ],
    );
  }
}
