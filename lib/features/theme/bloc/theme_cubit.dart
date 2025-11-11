import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:prac5/features/theme/bloc/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prac5/services/logger_service.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeInitial());

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeLoaded(themeMode));
      LoggerService.info('Тема загружена: ${isDark ? "темная" : "светлая"}');
    } catch (e) {
      LoggerService.error('Ошибка загрузки темы: $e');
      emit(const ThemeLoaded(ThemeMode.light));
    }
  }

  Future<void> toggleTheme() async {
    try {
      if (state is ThemeLoaded) {
        final currentState = state as ThemeLoaded;
        final newThemeMode = currentState.themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_themeKey, newThemeMode == ThemeMode.dark);

        emit(ThemeLoaded(newThemeMode));
        LoggerService.info('Тема переключена на: ${newThemeMode == ThemeMode.dark ? "темную" : "светлую"}');
      }
    } catch (e) {
      LoggerService.error('Ошибка переключения темы: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, themeMode == ThemeMode.dark);

      emit(ThemeLoaded(themeMode));
      LoggerService.info('Тема установлена: ${themeMode == ThemeMode.dark ? "темная" : "светлая"}');
    } catch (e) {
      LoggerService.error('Ошибка установки темы: $e');
    }
  }
}

