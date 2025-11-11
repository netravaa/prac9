import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_event.dart';
import 'package:prac5/features/recipes/bloc/recipes_state.dart';
import 'package:prac5/features/recipes/models/recipe.dart';
import 'package:prac5/features/recipes/data/repositories/recipes_repository.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/services/logger_service.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final RecipesRepository _repository;

  RecipesBloc({required RecipesRepository repository})
      : _repository = repository,
        super(const RecipesInitial()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<AddRecipe>(_onAddRecipe);
    on<UpdateRecipe>(_onUpdateRecipe);
    on<DeleteRecipe>(_onDeleteRecipe);
    on<ToggleRecipeRead>(_onToggleRecipeRead);
    on<RateRecipe>(_onRateRecipe);
  }

  Future<void> _onLoadRecipes(LoadRecipes event, Emitter<RecipesState> emit) async {
    try {
      emit(const RecipesLoading());
      final recipes = await _repository.getRecipes();
      emit(RecipesLoaded(recipes));
      LoggerService.info('Загружено рецептов: ${recipes.length}');
    } catch (e) {
      LoggerService.error('Ошибка загрузки рецептов: $e');
      emit(RecipesError('Не удалось загрузить рецепты: $e'));
    }
  }

  Future<void> _onAddRecipe(AddRecipe event, Emitter<RecipesState> emit) async {
    try {
      if (state is RecipesLoaded) {
        final currentState = state as RecipesLoaded;

        final imageUrl = await Services.image.getNextRecipeImage();
        final recipeWithImage = event.recipe.copyWith(imageUrl: imageUrl);

        await _repository.addRecipe(recipeWithImage);

        final updated = List<Recipe>.from(currentState.recipes)..add(recipeWithImage);

        emit(RecipesLoaded(updated));

        LoggerService.info('Добавлен рецепт: ${recipeWithImage.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка добавления рецепта: $e');
      emit(RecipesError('Не удалось добавить рецепт: $e'));
    }
  }

  Future<void> _onUpdateRecipe(UpdateRecipe event, Emitter<RecipesState> emit) async {
    try {
      if (state is RecipesLoaded) {
        final currentState = state as RecipesLoaded;

        await _repository.updateRecipe(event.recipe);

        final updated = currentState.recipes.map((recipe) {
          return recipe.id == event.recipe.id ? event.recipe : recipe;
        }).toList();

        emit(RecipesLoaded(updated));
        LoggerService.info('Обновлен рецепт: ${event.recipe.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка обновления рецепта: $e');
      emit(RecipesError('Не удалось обновить рецепт: $e'));
    }
  }

  Future<void> _onDeleteRecipe(DeleteRecipe event, Emitter<RecipesState> emit) async {
    try {
      if (state is RecipesLoaded) {
        final currentState = state as RecipesLoaded;
        final toDelete = currentState.recipes.firstWhere((recipe) => recipe.id == event.recipeId);

        if (toDelete.imageUrl != null) {
          await Services.image.releaseImage(toDelete.imageUrl!);
        }

        await _repository.deleteRecipe(event.recipeId);

        final updated = currentState.recipes.where((recipe) => recipe.id != event.recipeId).toList();

        emit(RecipesLoaded(updated));

        LoggerService.info('Удален рецепт: ${toDelete.title}');
      }
    } catch (e) {
      LoggerService.error('Ошибка удаления рецепта: $e');
      emit(RecipesError('Не удалось удалить рецепт: $e'));
    }
  }

  Future<void> _onToggleRecipeRead(ToggleRecipeRead event, Emitter<RecipesState> emit) async {
    try {
      if (state is RecipesLoaded) {
        final currentState = state as RecipesLoaded;
        final updated = currentState.recipes.map((recipe) {
          if (recipe.id == event.recipeId) {
            return recipe.copyWith(
              isRead: event.isRead,
              dateFinished: event.isRead ? DateTime.now() : null,
            );
          }
          return recipe;
        }).toList();

        final changed = updated.firstWhere((b) => b.id == event.recipeId);
        await _repository.updateRecipe(changed);

        emit(RecipesLoaded(updated));
        LoggerService.info('Статус изменен для ID: ${event.recipeId}');
      }
    } catch (e) {
      LoggerService.error('Ошибка смены статуса: $e');
      emit(RecipesError('Не удалось изменить статус: $e'));
    }
  }

  Future<void> _onRateRecipe(RateRecipe event, Emitter<RecipesState> emit) async {
    try {
      if (state is RecipesLoaded) {
        final currentState = state as RecipesLoaded;
        final updated = currentState.recipes.map((recipe) {
          if (recipe.id == event.recipeId) {
            return recipe.copyWith(rating: event.rating);
          }
          return recipe;
        }).toList();

        final changed = updated.firstWhere((b) => b.id == event.recipeId);
        await _repository.updateRecipe(changed);

        emit(RecipesLoaded(updated));
        LoggerService.info('Оценка изменена для ID: ${event.recipeId}, новая: ${event.rating}');
      }
    } catch (e) {
      LoggerService.error('Ошибка оценки: $e');
      emit(RecipesError('Не удалось изменить оценку: $e'));
    }
  }
}

