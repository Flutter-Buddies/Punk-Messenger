part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class HasUser extends LoginState {
  final Auth user;

  HasUser(this.user);
}