part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  LoginEvent([List user = const []]);
}
class SetUser extends LoginEvent {
  final Auth user;

  SetUser({this.user});
}