import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NumberTrivia extends Equatable {
  final String text;
  final int number;

  NumberTrivia({@required this.text, this.number});

  @override
  List<Object> get props => [text, number];
}
