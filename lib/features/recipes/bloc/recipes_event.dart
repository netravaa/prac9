import 'package:equatable/equatable.dart';
import 'package:prac5/features/recipes/models/recipe.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecipes extends RecipesEvent {
  const LoadRecipes();
}

class AddRecipe extends RecipesEvent {
  final Recipe recipe;

  const AddRecipe(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class UpdateRecipe extends RecipesEvent {
  final Recipe recipe;

  const UpdateRecipe(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class DeleteRecipe extends RecipesEvent {
  final String recipeId;

  const DeleteRecipe(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

class ToggleRecipeRead extends RecipesEvent {
  final String recipeId;
  final bool isRead;

  const ToggleRecipeRead(this.recipeId, this.isRead);

  @override
  List<Object?> get props => [recipeId, isRead];
}

class RateRecipe extends RecipesEvent {
  final String recipeId;
  final int rating;

  const RateRecipe(this.recipeId, this.rating);

  @override
  List<Object?> get props => [recipeId, rating];
}

