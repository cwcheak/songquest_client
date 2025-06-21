import 'package:songquest/repo/api/user.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final User? user;
  final Object? error;
  AccountLoaded(this.user, {this.error});
}

class AccountNeedSignIn extends AccountState {}
