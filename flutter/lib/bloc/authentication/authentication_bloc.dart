import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/data_repository/data_repository.dart';
import '../remember/remember_bloc.dart';
import '../remember/remember_event.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

/// Bloc for user authentication.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DataRepository _dataRepository;
  final RememberBloc _rememberBloc;

  /// Bloc for user authentication.
  AuthenticationBloc(
      {required DataRepository dataRepository,
      required RememberBloc rememberBloc})
      : _dataRepository = dataRepository,
        _rememberBloc = rememberBloc,
        super(const AuthenticationUnauthenticated());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationAppStarted) {
    } else if (event is AuthenticationRequested) {
      yield* _mapRequestToState(event);
    }
  }

  Stream<AuthenticationState> _mapRequestToState(
      AuthenticationRequested event) async* {
    yield const AuthenticationLoading();
    try {
      if (await _dataRepository.checkUser(event.identifier)) {
        yield AuthenticationAuthenticated(identifier: event.identifier);
        _rememberBloc.add(RememberLoginSucceeded(identifier: event.identifier));
      } else {
        yield const AuthenticationError(message: 'Identifier not found!');
      }
    } catch (e) {
      yield AuthenticationError(message: e.toString());
    }
  }
}
