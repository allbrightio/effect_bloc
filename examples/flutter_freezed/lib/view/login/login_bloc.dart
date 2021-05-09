import 'package:bloc/bloc.dart';
import 'package:effect_bloc/effect_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_bloc.freezed.dart';

///
/// State
///
@freezed
class LoginState with _$LoginState {
  const factory LoginState.content({
    required String email,
    required String password,
  }) = _Content;

  const factory LoginState.loading() = _Loading;
}

///
/// Effect
///

@freezed
class LoginEffect with _$LoginEffect {
  const factory LoginEffect.errorIO({required int code}) = _ErrorIO;

  const factory LoginEffect.errorInvalidCredentials() =
      _ErrorInvalidCredentials;

  const factory LoginEffect.loggedIn() = _loggedIn;
}

///
/// Bloc
///
class LoginBloc extends Cubit<LoginState>
    with BlocEffect<LoginState, LoginEffect> {
  LoginBloc() : super(LoginState.content(email: '', password: ''));

  Future<void> setEmail(String email) async {
    state.maybeMap(
        content: (state) {
          emit(state.copyWith(email: email));
        },
        orElse: () {});
  }

  Future<void> setPassword(String password) async {
    state.maybeMap(
        content: (state) {
          emit(state.copyWith(password: password));
        },
        orElse: () {});
  }

  Future<void> login() async {
    state.maybeMap(
        content: (state) async {
          final previousState = state;
          emit(LoginState.loading());

          final success = true; // TOOD replace with actual login flow

          await Future.delayed(Duration(seconds: 1));

          if (success) {
            emitEffect(LoginEffect.loggedIn());
          } else {
            emitEffect(LoginEffect.errorIO(code: 404));
            emit(previousState);
          }
        },
        orElse: () {});
  }
}
