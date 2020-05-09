import 'package:fluttertest/features/cat_breeds/domain/entities/cat_breeds.dart';
import 'package:meta/meta.dart';

class CatBreedsModel extends CatBreeds {
  CatBreedsModel({
    @required String id,
    @required String name,
    @required String description,
  }) : super(id: id, name: name, description: description);

  factory CatBreedsModel.fromJson(Map<String, dynamic> json) {
    return CatBreedsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
