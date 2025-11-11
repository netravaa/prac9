import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:prac5/app.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/core/bloc/app_bloc_observer.dart';
import 'package:prac5/services/logger_service.dart';

const bool RESET_IMAGE_CACHE_ON_START = true;

const String _keyUsedImages = 'used_images';
const String _keyAvailableImages = 'available_images';
const String _keyUsedAvatars = 'used_avatars';
const String _keyAvailableAvatars = 'available_avatars';

Future<void> _resetImageStateIfNeeded() async {
  if (!RESET_IMAGE_CACHE_ON_START) return;

  try {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyUsedImages);
    await prefs.remove(_keyAvailableImages);
    await prefs.remove(_keyUsedAvatars);
    await prefs.remove(_keyAvailableAvatars);

    await DefaultCacheManager().emptyCache();

    LoggerService.warning('ImageService: состояние и файловый кэш очищены (миграция с picsum).');
  } catch (e) {
    LoggerService.error('Не удалось очистить состояние ImageService', e);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await setupServiceLocator();

  await _resetImageStateIfNeeded();

  runApp(const RecipesApp());
}
