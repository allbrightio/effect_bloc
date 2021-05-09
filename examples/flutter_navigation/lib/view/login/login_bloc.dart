import 'package:bloc/bloc.dart';

abstract class LoginState {}

class IdleState extends LoginState {}

class LoginBloc extends Cubit<LoginState> {
  LoginBloc(LoginState initialState) : super(initialState);
}
