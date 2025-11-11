import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          if (state is RecipesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! RecipesLoaded) {
            return const Center(child: Text('Ошибка загрузки'));
          }

          final totalBooks = state.totalRecipes;
          final readBooks = state.readRecipes;
          final wantToRead = state.wantToReadRecipes;
          final averageRating = state.averageRating;
          final progress = totalBooks > 0 ? (readBooks / totalBooks * 100) : 0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildStatCard(
                title: 'Общая статистика',
                icon: Icons.restaurant,
                color: Colors.blue,
                children: [
                  _buildStatRow('Всего рецептов', totalBooks.toString()),
                  _buildStatRow('Приготовленно', readBooks.toString()),
                  _buildStatRow('В планах', wantToRead.toString()),
                  _buildStatRow('Прогресс', '${progress.toStringAsFixed(0)}%'),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Оценки',
                icon: Icons.star,
                color: Colors.amber,
                children: [
                  _buildStatRow(
                    'Средняя оценка',
                    averageRating.toStringAsFixed(1),
                  ),
                  _buildStatRow(
                    'Оценено рецептов',
                    state.recipes.where((b) => b.rating != null).length.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'По категориям',
                icon: Icons.category,
                color: Colors.green,
                children: _buildGenreStats(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGenreStats(RecipesLoaded state) {
    final genreMap = <String, int>{};
    for (var recipe in state.recipes) {
      genreMap[recipe.genre] = (genreMap[recipe.genre] ?? 0) + 1;
    }

    final sortedGenres = genreMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedGenres.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Нет данных',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ];
    }

    return sortedGenres
        .map((entry) => _buildStatRow(entry.key, entry.value.toString()))
        .toList();
  }
}


