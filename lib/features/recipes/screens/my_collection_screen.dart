import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/recipes/widgets/recipe_tile.dart';
import 'package:prac5/features/recipes/bloc/recipes_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_state.dart';
import 'package:prac5/shared/widgets/empty_state.dart';

class MyCollectionScreen extends StatelessWidget {
  const MyCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя коллекция'),
      ),
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          if (state is RecipesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! RecipesLoaded) {
            return const Center(child: Text('Ошибка загрузки'));
          }

          final recipes = state.recipes;

          if (recipes.isEmpty) {
            return const EmptyState(
              icon: Icons.restaurant_menu,
              title: 'Коллекция пуста',
              subtitle: 'Добавьте книги в свою коллекцию',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeTile(
                key: ValueKey(recipe.id),
                recipe: recipe,
              );
            },
          );
        },
      ),
    );
  }
}


