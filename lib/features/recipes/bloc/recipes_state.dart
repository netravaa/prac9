import 'package:equatable/equatable.dart';
import 'package:prac5/features/recipes/models/recipe.dart';

abstract class RecipesState extends Equatable {
  const RecipesState();

  @override
  List<Object?> get props => [];
}

class RecipesInitial extends RecipesState {
  const RecipesInitial();
}

class RecipesLoading extends RecipesState {
  const RecipesLoading();
}

class RecipesLoaded extends RecipesState {
  final List<Recipe> recipes;

  const RecipesLoaded(this.recipes);

  @override
  List<Object?> get props => [recipes];

  int get totalRecipes => recipes.length;

  int get readRecipes => recipes.where((recipe) => recipe.isRead).length;

  int get wantToReadRecipes => totalRecipes - readRecipes;

  double get averageRating {
    final ratedRecipes = recipes.where((recipe) => recipe.rating != null);
    if (ratedRecipes.isEmpty) return 0.0;

    final sum = ratedRecipes.map((recipe) => recipe.rating!).reduce((a, b) => a + b);
    return sum / ratedRecipes.length;
  }

  List<Recipe> get recentRecipes {
    if (recipes.isEmpty) return [];

    final sorted = recipes.toList()
      ..sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return sorted.take(3).toList();
  }

  List<Recipe> get readRecipesList => recipes.where((recipe) => recipe.isRead).toList();

  List<Recipe> get wantToReadRecipesList => recipes.where((recipe) => !recipe.isRead).toList();
}

class RecipesError extends RecipesState {
  final String message;

  const RecipesError(this.message);

  @override
  List<Object?> get props => [message];
}


