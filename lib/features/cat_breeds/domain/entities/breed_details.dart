import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BreedDetails extends Equatable {
  final String url;

  BreedDetails({
    @required this.url,
  });

  @override
  List<Object> get props => [url];
}
