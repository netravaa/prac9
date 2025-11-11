import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/shared/app_theme.dart';
import 'package:prac5/features/recipes/bloc/recipes_bloc.dart';
import 'package:prac5/features/recipes/bloc/recipes_event.dart';
import 'package:prac5/features/auth/bloc/auth_bloc.dart';
import 'package:prac5/features/auth/bloc/auth_event.dart';
import 'package:prac5/features/auth/bloc/auth_state.dart';
import 'package:prac5/features/profile/bloc/profile_cubit.dart';
import 'package:prac5/features/theme/bloc/theme_cubit.dart';
import 'package:prac5/features/theme/bloc/theme_state.dart';
import 'package:prac5/core/router/app_router.dart';
import 'package:prac5/core/di/service_locator.dart';

class RecipesApp extends StatelessWidget {
  const RecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: Services.auth,
          )..add(const CheckAccount()),
        ),
        BlocProvider(
          create: (context) => RecipesBloc(
            repository: Repositories.recipes,
          )..add(const LoadRecipes()),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(
            profileService: Services.profile,
          )..loadProfile(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..loadTheme(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.light;

          return BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthLogin || authState is AuthRegister) {
                AppRouter.router.go('/auth');
              } else if (authState is Authenticated) {
                AppRouter.router.go('/');
              }
            },
            child: MaterialApp.router(
              title: 'Кулинарная книга',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}
