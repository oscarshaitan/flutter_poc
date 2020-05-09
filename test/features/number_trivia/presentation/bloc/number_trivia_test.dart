import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/core/error/failures.dart';
import 'package:fluttertest/core/usecase/usecase.dart';
import 'package:fluttertest/core/util/input_converter.dart';
import 'package:fluttertest/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertest/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:fluttertest/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:fluttertest/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    // Then
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final numberString = '123';
    final numberParsed = 123;
    final numberTrivia = NumberTrivia(number: 123, text: 'test trivia');
    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(numberParsed));
    test(
      'should call InputConverter and conver the string to unsigned integer',
      () async {
        // Given
        setUpMockInputConverterSuccess();
        // When
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any))
            .timeout(Duration(seconds: 10));

        // Then
        verify(mockInputConverter.stringToUnsignedInteger(numberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // Given
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        // Then Later
        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));

        // When
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // Given
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(numberTrivia));
        // When
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
        await untilCalled(mockGetConcreteNumberTrivia(any))
            .timeout(Duration(seconds: 10));
        // Then
        verify(mockGetConcreteNumberTrivia(numberParsed));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Given
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(numberTrivia));
        // Then later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: numberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // When
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Given
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // Then later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // When
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
      },
    );

    test(
      'should emit [Loading, Error] with proper message for the error when gettin data fails',
      () async {
        // Given
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // Then later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // When
        bloc.add(GetTriviaForConcreteNumberEvent(numberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final numberTrivia = NumberTrivia(number: 123, text: 'test trivia');
    test(
      'should2 get data from the random use case',
      () async {
        // Given
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(numberTrivia));
        // When
        bloc.add(GetTriviaForRandomNumberEvent());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // Then
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // Given
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(numberTrivia));
        // Then later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: numberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // When
        bloc.add(GetTriviaForRandomNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // Given
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // Then later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // When
        bloc.add(GetTriviaForRandomNumberEvent());
      },
    );

    test(
      'should emit [Loading, Error] with proper message for the error when gettin data fails',
      () async {
        // Given
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // Then later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // When
        bloc.add(GetTriviaForRandomNumberEvent());
      },
    );
  });
}
