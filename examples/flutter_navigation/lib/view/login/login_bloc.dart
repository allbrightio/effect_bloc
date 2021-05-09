import 'package:bloc/bloc.dart';
import 'package:effect_bloc/effect_bloc.dart';

import 'package:flutter_navigation/utils.dart';

///
/// State
///
abstract class LoginState {}

class ContentState implements LoginState {
  final String email;
  final String password;

  ContentState({required this.email, required this.password});

  bool operator ==(o) =>
      o is ContentState && email == o.email && password == o.password;
  int get hashCode => Hash.hash2(email.hashCode, password.hashCode);
}

class LoadingState extends LoginState {}

///
/// Effect
///
enum LoginEffect {
  errorIO,
  errorInvalidCredentials,
  loggedIn,
}

///
/// Bloc
///
class LoginBloc extends Cubit<LoginState>
    with BlocEffect<LoginState, LoginEffect> {
  LoginBloc() : super(ContentState(email: '', password: ''));

  Future<void> setEmail(String email) async {
    if (state is ContentState) {
      emit(ContentState(
          email: email, password: (state as ContentState).password));
    }
  }

  Future<void> setPassword(String password) async {
    if (state is ContentState) {
      emit(ContentState(
          email: (state as ContentState).email, password: password));
    }
  }

  Future<void> login() async {
    if (state is ContentState) {
      final previousState = state as ContentState;
      emit(LoadingState());

      final success = true; // TOOD replace with actual login flow

      await Future.delayed(Duration(seconds: 1));

      if (success) {
        emitEffect(LoginEffect.loggedIn);
      } else {
        emitEffect(LoginEffect.errorInvalidCredentials);
        emit(previousState);
      }
    }
  }
}
