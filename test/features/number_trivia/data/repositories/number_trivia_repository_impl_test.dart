import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/core/error/exception.dart';
import 'package:fluttertest/core/error/failures.dart';
import 'package:fluttertest/core/platform/network_info.dart';
import 'package:fluttertest/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:fluttertest/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:fluttertest/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:fluttertest/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:fluttertest/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final number = 1;
    final numberTriviaModel = NumberTriviaModel(number: number, text: "test");
    final NumberTrivia numberTrivia = numberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // Given
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // When
        repository.getConcreteNumberTrivia(number);
        // Then
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is sucess',
        () async {
          // Given
          when(mockRemoteDataSource.getConcreteNumberTrivia(number))
              .thenAnswer((_) async => numberTriviaModel);
          // When
          final result = await repository.getConcreteNumberTrivia(number);
          // Then
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          expect(result, equals(Right(numberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is sucess',
        () async {
          // Given
          when(mockRemoteDataSource.getConcreteNumberTrivia(number))
              .thenAnswer((_) async => numberTriviaModel);
          // When
          final result = await repository.getConcreteNumberTrivia(number);
          // Then
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          verify(mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
        },
      );

      test(
        'should return server faliure when the call to remote data source is unsuccessfull',
        () async {
          // Given
          when(mockRemoteDataSource.getConcreteNumberTrivia(number))
              .thenThrow(ServerException());
          // When
          final result = await repository.getConcreteNumberTrivia(number);
          // Then
          verify(mockRemoteDataSource.getConcreteNumberTrivia(number));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should the last locally data when the cache data is present',
        () async {
          // Given
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);
          // When
          final result = await repository.getConcreteNumberTrivia(number);
          // Then
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(numberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // Given
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // When
          final result = await repository.getConcreteNumberTrivia(number);
          // Then
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    final numberTriviaModel = NumberTriviaModel(number: 1, text: "test");
    final NumberTrivia numberTrivia = numberTriviaModel;

    test(
      'should check if the device is online',
      () async {
        // Given
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // When
        repository.getRandomNumberTrivia();
        // Then
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is sucess',
        () async {
          // Given
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);
          // When
          final result = await repository.getRandomNumberTrivia();
          // Then
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(numberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is sucess',
        () async {
          // Given
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);
          // When
          final result = await repository.getRandomNumberTrivia();
          // Then
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(numberTriviaModel));
        },
      );

      test(
        'should return server faliure when the call to remote data source is unsuccessfull',
        () async {
          // Given
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // When
          final result = await repository.getRandomNumberTrivia();
          // Then
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should the last locally data when the cache data is present',
        () async {
          // Given
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => numberTriviaModel);
          // When
          final result = await repository.getRandomNumberTrivia();
          // Then
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(numberTrivia)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // Given
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // When
          final result = await repository.getRandomNumberTrivia();
          // Then
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
