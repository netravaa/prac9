import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prac5/features/auth/bloc/auth_event.dart';
import 'package:prac5/features/auth/bloc/auth_state.dart';
import 'package:prac5/services/auth_service.dart';
import 'package:prac5/services/logger_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {
    on<CheckAccount>(_onCheckAccount);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ToggleAuthMode>(_onToggleAuthMode);
  }

  Future<void> _onCheckAccount(CheckAccount event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthChecking());
      final hasAccount = await _authService.hasAccount();

      if (hasAccount) {
        emit(const AuthLogin());
      } else {
        emit(const AuthRegister());
      }

      LoggerService.info('AuthBloc: Проверка аккаунта - ${hasAccount ? "есть" : "нет"}');
    } catch (e) {
      LoggerService.error('AuthBloc: Ошибка проверки аккаунта: $e');
      emit(const AuthRegister());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading(true));

      final success = await _authService.login(event.username, event.password);

      if (success) {
        LoggerService.info('AuthBloc: Успешный вход для ${event.username}');
        emit(Authenticated(event.username));
      } else {
        LoggerService.warning('AuthBloc: Неудачная попытка входа для ${event.username}');
        emit(const AuthFailure('Неверный логин или пароль', true));
      }
    } catch (e) {
      LoggerService.error('AuthBloc: Ошибка входа: $e');
      emit(AuthFailure('Ошибка входа: $e', true));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading(false));

      final success = await _authService.register(event.username, event.password);

      if (success) {
        LoggerService.info('AuthBloc: Успешная регистрация для ${event.username}');
        emit(Authenticated(event.username));
      } else {
        LoggerService.warning('AuthBloc: Неудачная регистрация для ${event.username}');
        emit(const AuthFailure('Ошибка регистрации', false));
      }
    } catch (e) {
      LoggerService.error('AuthBloc: Ошибка регистрации: $e');
      emit(AuthFailure('Ошибка регистрации: $e', false));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      await _authService.logout();
      LoggerService.info('AuthBloc: Выход из системы');
      emit(const AuthLogin());
    } catch (e) {
      LoggerService.error('AuthBloc: Ошибка выхода: $e');
    }
  }

  Future<void> _onToggleAuthMode(ToggleAuthMode event, Emitter<AuthState> emit) async {
    if (state is AuthLogin) {
      emit(const AuthRegister());
    } else if (state is AuthRegister) {
      emit(const AuthLogin());
    } else if (state is AuthFailure) {
      final currentState = state as AuthFailure;
      if (currentState.isLogin) {
        emit(const AuthRegister());
      } else {
        emit(const AuthLogin());
      }
    }
  }
}

