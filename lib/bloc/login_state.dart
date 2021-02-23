part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  LoginState([List user = const []]);
}

class LoginInitial extends LoginState {
  final Auth user;

  LoginInitial([this.user]) : super([user]);
  String toString() => 'LoginInitial {user: $user}';
}

class HasUser extends LoginState {
  final Auth user;

  HasUser([this.user]) : super([user]);

  @override
  String toString() => 'HasUser { user: $user}';
}
