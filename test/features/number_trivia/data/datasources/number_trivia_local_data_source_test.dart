import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/core/error/exception.dart';
import 'package:fluttertest/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:fluttertest/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../mockassets/mock_assets_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final numberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(mockedResponse('trivia_cached.json')));
    test(
      'should return NumberTrivia from ShaePReferences when there is one in the cache',
      () async {
        // Given
        when(mockSharedPreferences.getString(any))
            .thenReturn(mockedResponse('trivia_cached.json'));

        // When
        final result = await dataSource.getLastNumberTrivia();
        // Then
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(numberTriviaModel));
      },
    );

    test(
      'should throw CacheExeption when there is not a chached value',
      () async {
        // Given
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // When
        final call = dataSource.getLastNumberTrivia;
        // Then
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final numberTriviaModel = NumberTriviaModel(text: "text trivia", number: 1);
    test(
      'should call harePreferences to cache the data',
      () async {
        // When
        dataSource.cacheNumberTrivia(numberTriviaModel);
        // Then
        final expectedJsonStrong = json.encode(numberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonStrong));
      },
    );
  });
}
