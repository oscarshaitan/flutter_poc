import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CatBreeds extends Equatable {
  final String id;
  final String name;
  final String description;

  CatBreeds({
    @required this.id,
    @required this.name,
    @required this.description,
  });

  @override
  List<Object> get props => [id, name, description];
}
