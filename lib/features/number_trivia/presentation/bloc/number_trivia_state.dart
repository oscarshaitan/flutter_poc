import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState();
}

class InitialNumberTriviaState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}
