import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prac5/features/recipes/models/recipe.dart';
import 'package:prac5/services/logger_service.dart';

class RecipesLocalDataSource {
  static const String _recipesKey = 'recipes_data';

  Future<List<Recipe>> getRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? recipesJson = prefs.getString(_recipesKey);

      if (recipesJson == null || recipesJson.isEmpty) {
        LoggerService.info('RecipesLocalDataSource: пустой список');
        return [];
      }

      final List<dynamic> decoded = json.decode(recipesJson);
      final recipes = decoded.map((json) => _recipeFromJson(json)).toList();

      LoggerService.info('RecipesLocalDataSource: загружено ${recipes.length} элементов');
      return recipes;
    } catch (e) {
      LoggerService.error('RecipesLocalDataSource: ошибка загрузки: $e');
      return [];
    }
  }

  Future<void> saveRecipes(List<Recipe> recipes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recipesJson = json.encode(recipes.map((recipe) => _recipeToJson(recipe)).toList());
      await prefs.setString(_recipesKey, recipesJson);

      LoggerService.info('RecipesLocalDataSource: сохранено ${recipes.length} элементов');
    } catch (e) {
      LoggerService.error('RecipesLocalDataSource: ошибка сохранения: $e');
      rethrow;
    }
  }

  Future<void> clearRecipes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recipesKey);
      LoggerService.info('RecipesLocalDataSource: очищено хранилище');
    } catch (e) {
      LoggerService.error('RecipesLocalDataSource: ошибка очистки: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _recipeToJson(Recipe recipe) {
    return {
      'id': recipe.id,
      'title': recipe.title,
      'author': recipe.author,
      'genre': recipe.genre,
      'description': recipe.description,
      'pages': recipe.pages,
      'isRead': recipe.isRead,
      'rating': recipe.rating,
      'dateAdded': recipe.dateAdded.toIso8601String(),
      'dateFinished': recipe.dateFinished?.toIso8601String(),
      'imageUrl': recipe.imageUrl,
    };
  }

  Recipe _recipeFromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      genre: json['genre'] as String,
      description: json['description'] as String?,
      pages: json['pages'] as int?,
      isRead: json['isRead'] as bool? ?? false,
      rating: json['rating'] as int?,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      dateFinished: json['dateFinished'] != null
          ? DateTime.parse(json['dateFinished'] as String)
          : null,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

