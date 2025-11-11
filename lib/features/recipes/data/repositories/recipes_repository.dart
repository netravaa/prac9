import 'package:prac5/features/recipes/models/recipe.dart';

abstract class RecipesRepository {
  Future<List<Recipe>> getRecipes();

  Future<void> addRecipe(Recipe recipe);

  Future<void> updateRecipe(Recipe recipe);

  Future<void> deleteRecipe(String id);

  Future<void> saveRecipes(List<Recipe> recipes);
}

