import 'package:equatable/equatable.dart';

abstract class CatsState extends Equatable {
  CatsState();
}

class InitialCatsState extends CatsState {
  @override
  List<Object> get props => [];
}
