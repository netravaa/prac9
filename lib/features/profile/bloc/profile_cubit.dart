import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/profile/bloc/profile_state.dart';
import 'package:prac5/services/profile_service.dart';
import 'package:prac5/core/di/service_locator.dart';
import 'package:prac5/services/logger_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _profileService;

  ProfileCubit({required ProfileService profileService})
      : _profileService = profileService,
        super(const ProfileInitial());

  Future<void> loadProfile() async {
    try {
      emit(const ProfileLoading());
      final profile = await _profileService.getProfile();
      emit(ProfileLoaded(profile));
      LoggerService.info('ProfileCubit: Профиль загружен для ${profile.nickname}');
    } catch (e) {
      LoggerService.error('ProfileCubit: Ошибка загрузки профиля: $e');
      emit(ProfileError('Не удалось загрузить профиль: $e'));
    }
  }

  Future<void> updateNickname(String nickname) async {
    try {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;

        if (nickname.trim().isEmpty) {
          emit(ProfileError('Никнейм не может быть пустым', profile: currentState.profile));
          emit(currentState);
          return;
        }

        emit(ProfileUpdating(currentState.profile));

        await _profileService.updateNickname(nickname);

        final updatedProfile = UserProfile(
          id: currentState.profile.id,
          nickname: nickname,
          avatarUrl: currentState.profile.avatarUrl,
        );

        emit(ProfileLoaded(updatedProfile, isEditing: false));

        LoggerService.info('ProfileCubit: Никнейм обновлен на $nickname');
      }
    } catch (e) {
      LoggerService.error('ProfileCubit: Ошибка обновления никнейма: $e');
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(ProfileError('Не удалось обновить никнейм: $e', profile: currentState.profile));
        emit(currentState);
      }
    }
  }

  Future<void> changeAvatar() async {
    try {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;

        emit(ProfileUpdating(currentState.profile));

        final newAvatarUrl = await Services.image.getNextAvatar();

        if (newAvatarUrl == null) {
          emit(ProfileError(
            'Нет доступных аватарок. Требуется интернет для загрузки новых.',
            profile: currentState.profile,
          ));
          emit(currentState);
          return;
        }

        await _profileService.updateAvatar(newAvatarUrl);

        final updatedProfile = UserProfile(
          id: currentState.profile.id,
          nickname: currentState.profile.nickname,
          avatarUrl: newAvatarUrl,
        );

        emit(ProfileLoaded(updatedProfile, isEditing: currentState.isEditing));

        LoggerService.info('ProfileCubit: Аватар обновлен');
      }
    } catch (e) {
      LoggerService.error('ProfileCubit: Ошибка изменения аватара: $e');
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(ProfileError('Не удалось изменить аватар: $e', profile: currentState.profile));
        emit(currentState);
      }
    }
  }

  void startEditing() {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isEditing: true));
    }
  }

  void cancelEditing() {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isEditing: false));
    }
  }
}

