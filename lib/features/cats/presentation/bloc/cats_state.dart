import 'package:equatable/equatable.dart';

abstract class CatsState extends Equatable {
  const CatsState();
}

class InitialCatsState extends CatsState {
  @override
  List<Object> get props => [];
}
