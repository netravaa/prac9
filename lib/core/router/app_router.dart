import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/features/auth/auth_screen.dart';
import 'package:prac5/features/recipes/screens/home_screen.dart';
import 'package:prac5/features/recipes/screens/read_recipes_screen.dart';
import 'package:prac5/features/recipes/screens/want_to_read_screen.dart';
import 'package:prac5/features/recipes/screens/all_recipes_screen.dart';
import 'package:prac5/features/recipes/screens/recipe_detail_screen.dart';
import 'package:prac5/features/recipes/screens/recipe_form_screen.dart';
import 'package:prac5/features/recipes/screens/my_collection_screen.dart';
import 'package:prac5/features/recipes/screens/ratings_screen.dart';
import 'package:prac5/features/recipes/screens/statistics_screen.dart';
import 'package:prac5/features/profile/profile_screen.dart';
import 'package:prac5/features/recipes/models/recipe.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isLoggedIn = await Services.auth.isLoggedIn();
      final isGoingToAuth = state.matchedLocation == '/auth';

      if (!isLoggedIn && !isGoingToAuth) {
        return '/auth';
      }

      if (isLoggedIn && isGoingToAuth) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/read-recipes',
        name: 'read-recipes',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Приготовленные рецепты'),
          ),
          body: const ReadRecipesScreen(),
        ),
      ),
      GoRoute(
        path: '/want-to-read',
        name: 'want-to-read',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Хочу приготовить'),
          ),
          body: const WantToReadScreen(),
        ),
      ),
      GoRoute(
        path: '/all-recipes',
        name: 'all-recipes',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Все рецепты'),
          ),
          body: const AllRecipesScreen(),
        ),
      ),
      GoRoute(
        path: '/my-collection',
        name: 'my-collection',
        builder: (context, state) => const MyCollectionScreen(),
      ),
      GoRoute(
        path: '/ratings',
        name: 'ratings',
        builder: (context, state) => const RatingsScreen(),
      ),
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: '/recipe/:id',
        name: 'recipe-detail',
        builder: (context, state) {
          final recipe = state.extra as Recipe;
          return RecipeDetailScreen(recipe: recipe);
        },
      ),
      GoRoute(
        path: '/recipe-form',
        name: 'recipe-form',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          final onSave = params?['onSave'] as Function(Recipe)?;
          final recipe = params?['recipe'] as Recipe?;

          return RecipeFormScreen(
            onSave: onSave ?? (recipe) {},
            recipe: recipe,
          );
        },
      ),
    ],
  );
}
