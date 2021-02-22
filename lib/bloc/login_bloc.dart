import 'dart:async';

import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  Auth _user;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {    if (event is HasUser) {
      yield HasUser(_user);
    } else if (event is SetUser) {
      await this._handleSetUser(event.user);
      yield HasUser(_user);
    }
  }

  Future<void> _handleSetUser(Auth user) async {
    _user = user;
  }
}
