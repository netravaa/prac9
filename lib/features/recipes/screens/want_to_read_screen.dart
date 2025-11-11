import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/recipes/widgets/recipe_tile.dart';
import 'package:prac5/features/recipes/bloc/recipes_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class WantToReadScreen extends StatelessWidget {
  const WantToReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesBloc, RecipesState>(
      builder: (context, state) {
        if (state is! RecipesLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final wantToReadBooks = state.wantToReadRecipesList;
        final sortedBooks = wantToReadBooks.toList()
          ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));

        return wantToReadBooks.isEmpty
            ? const EmptyState(
                icon: Icons.schedule_outlined,
                title: 'В планах пусто',
                subtitle: 'Добавьте рецепты, чтобы видеть список планов',
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

