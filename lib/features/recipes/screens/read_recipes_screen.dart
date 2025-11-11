import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/recipes/widgets/recipe_tile.dart';
import 'package:prac5/features/recipes/bloc/recipes_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class ReadRecipesScreen extends StatelessWidget {
  const ReadRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesBloc, RecipesState>(
      builder: (context, state) {
        if (state is! RecipesLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final readBooks = state.readRecipesList;

        final sortedBooks = readBooks.toList()
          ..sort((a, b) {
            if (a.dateFinished == null && b.dateFinished == null) return 0;
            if (a.dateFinished == null) return 1;
            if (b.dateFinished == null) return -1;
            return b.dateFinished!.compareTo(a.dateFinished!);
          });

        return readBooks.isEmpty
            ? const EmptyState(
                icon: Icons.check_circle_outline,
                title: 'Пока нет приготовленных рецептов',
                subtitle: 'Отметьте рецепты как приготовленные',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: sortedBooks.length,
                itemBuilder: (context, index) {
                  final recipe = sortedBooks[index];
                  return RecipeTile(
                    key: ValueKey(recipe.id),
                    recipe: recipe,
                  );
                },
              );
      },
    );
  }
}

