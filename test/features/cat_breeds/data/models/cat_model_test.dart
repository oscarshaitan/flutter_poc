import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/features/cat_breeds/data/models/cat_breeds_model.dart';
import 'package:fluttertest/features/cat_breeds/domain/entities/cat_breeds.dart';

import '../../../../mockassets/mock_assets_reader.dart';

void main() {
  final tCatModel = CatBreedsModel(
    id: 'abys',
    name: 'Abyssinian',
    description:
        'The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.',
  );

  test(
    'should be a subclass of CatBreeds entity',
    () async {
      // assert
      expect(tCatModel, isA<CatBreeds>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid CatBreeds model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(mockedResponse('cats/cat.json'));
        // act
        final result = CatBreedsModel.fromJson(jsonMap);
        // assert
        expect(result, tCatModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tCatModel.toJson();
        // assert
        final expectedMap = {
          "id": "abys",
          "name": "Abyssinian",
          "description":
              "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
        };
        expect(result, expectedMap);
      },
    );
  });
}
