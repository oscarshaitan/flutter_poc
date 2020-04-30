import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/core/error/exception.dart';
import 'package:fluttertest/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:fluttertest/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../../../mockassets/mock_assets_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(mockedResponse('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Somethingwent wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final number = 1;
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(mockedResponse('trivia.json')));
    test(
      '''should perform a GET request on a URL with number being the 
      endpoint and with application/json header''',
      () async {
        // Given
        setUpMockHttpClientSuccess200();
        // When
        dataSource.getConcreteNumberTrivia(number);
        // Then
        verify(mockHttpClient.get(
          'http://numbersapi.com/$number',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when response code is 200(sucess)',
      () async {
        // Given
        setUpMockHttpClientSuccess200();
        // When
        final result = await dataSource.getConcreteNumberTrivia(number);
        // Then
        expect(result, equals(numberTriviaModel));
      },
    );

    test(
      'should throw  SErverException when the response code is 404 or other',
      () async {
        // Given
        setUpMockHttpClientFailure404();
        // When
        final call = dataSource.getConcreteNumberTrivia;
        // Then
        expect(() => call(number), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(mockedResponse('trivia.json')));
    test(
      '''should perform a GET request on a URL with number being the 
      endpoint and with application/json header''',
      () async {
        // Given
        setUpMockHttpClientSuccess200();
        // When
        dataSource.getRandomNumberTrivia();
        // Then
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when response code is 200(sucess)',
      () async {
        // Given
        setUpMockHttpClientSuccess200();
        // When
        final result = await dataSource.getRandomNumberTrivia();
        // Then
        expect(result, equals(numberTriviaModel));
      },
    );

    test(
      'should throw  SErverException when the response code is 404 or other',
      () async {
        // Given
        setUpMockHttpClientFailure404();
        // When
        final call = dataSource.getRandomNumberTrivia;
        // Then
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
