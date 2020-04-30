import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class CatsBloc extends Bloc<CatsEvent, CatsState> {
  @override
  CatsState get initialState => InitialCatsState();

  @override
  Stream<CatsState> mapEventToState(
    CatsEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
