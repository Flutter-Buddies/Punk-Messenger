part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SetUser extends LoginEvent {
  final Auth user;

  SetUser({this.user});
}
