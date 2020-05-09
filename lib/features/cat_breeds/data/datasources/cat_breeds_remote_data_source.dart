import 'dart:convert';

import 'package:fluttertest/core/error/exception.dart';
import 'package:fluttertest/features/cat_breeds/data/models/breed_details_model.dart';
import 'package:fluttertest/features/cat_breeds/data/models/cat_breeds_model.dart';
import 'package:fluttertest/features/cat_breeds/domain/entities/breed_details.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class CatBreedsRemoteDataSource {
  /// Calls the https://api.thecatapi.com/v1/breeds? endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<CatBreedsModel> getCatBreeds();

  /// Calls the https://api.thecatapi.com/v1/images/search?breed_id={breedId} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<BreedDetails> getBreedDetails(String breedId);
}

class CatBreedsRemoteDataSourceImpl implements CatBreedsRemoteDataSource{
  final http.Client client;

  CatBreedsRemoteDataSourceImpl({@required this.client});

  @override
  Future<CatBreedsModel> getCatBreeds() async {
    final response = await client.get("https://api.thecatapi.com/v1/breeds?", headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return CatBreedsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BreedDetails> getBreedDetails(String breedId) async {
    final response = await client.get('https://api.thecatapi.com/v1/images/search?breed_id=$breedId', headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return BreedDetailsModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
