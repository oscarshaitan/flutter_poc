import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/features/cat_breeds/data/models/breed_details_model.dart';
import 'package:fluttertest/features/cat_breeds/domain/entities/breed_details.dart';

import '../../../../mockassets/mock_assets_reader.dart';

void main() {
  final tBreedDetails = BreedDetailsModel(
    url: 'https://cdn2.thecatapi.com/images/xnzzM6MBI.jpg',
  );

  test(
    'should be a subclass of BreedDetails entity',
        () async {
      // assert
      expect(tBreedDetails, isA<BreedDetails>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid BreedDetails model',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap =
        json.decode(mockedResponse('cats/breed_details.json'));
        // act
        final result = BreedDetailsModel.fromJson(jsonMap);
        // assert
        expect(result, tBreedDetails);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
          () async {
        // act
        final result = tBreedDetails.toJson();
        // assert
        final expectedMap = {
          "url": "https://cdn2.thecatapi.com/images/xnzzM6MBI.jpg",
        };
        expect(result, expectedMap);
      },
    );
  });
}
