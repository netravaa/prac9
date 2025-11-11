import 'package:prac5/features/recipes/models/recipe.dart';
import 'package:prac5/features/recipes/data/repositories/recipes_repository.dart';
import 'package:prac5/features/recipes/data/datasources/recipes_local_datasource.dart';
import 'package:prac5/services/logger_service.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  final RecipesLocalDataSource _localDataSource;

  RecipesRepositoryImpl({
    required RecipesLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<List<Recipe>> getRecipes() async {
    try {
      return await _localDataSource.getRecipes();
    } catch (e) {
      LoggerService.error('RecipesRepository: ошибка получения: $e');
      rethrow;
    }
  }

  @override
  Future<void> addRecipe(Recipe recipe) async {
    try {
      final recipes = await getRecipes();
      recipes.add(recipe);
      await _localDataSource.saveRecipes(recipes);
      LoggerService.info('RecipesRepository: добавлен рецепт: ${recipe.title}');
    } catch (e) {
      LoggerService.error('RecipesRepository: ошибка добавления: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      final recipes = await getRecipes();
      final index = recipes.indexWhere((b) => b.id == recipe.id);

      if (index != -1) {
        recipes[index] = recipe;
        await _localDataSource.saveRecipes(recipes);
        LoggerService.info('RecipesRepository: обновлен рецепт: ${recipe.title}');
      } else {
        throw Exception('Рецепт с ID ${recipe.id} не найден');
      }
    } catch (e) {
      LoggerService.error('RecipesRepository: ошибка обновления: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      final recipes = await getRecipes();
      recipes.removeWhere((recipe) => recipe.id == id);
      await _localDataSource.saveRecipes(recipes);
      LoggerService.info('RecipesRepository: удален рецепт: $id');
    } catch (e) {
      LoggerService.error('RecipesRepository: ошибка удаления: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveRecipes(List<Recipe> recipes) async {
    try {
      await _localDataSource.saveRecipes(recipes);
    } catch (e) {
      LoggerService.error('RecipesRepository: ошибка сохранения: $e');
      rethrow;
    }
  }
}

