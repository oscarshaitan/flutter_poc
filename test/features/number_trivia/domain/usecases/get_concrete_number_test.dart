import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:fluttertest/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:fluttertest/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final number = 1;
  final numberTrivia = NumberTrivia(number: 1, text: "text test");

  test(
    'should get trivia number from the repository',
    () async {
      // Given
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTrivia));
      // When
      final result = await useCase(number);
      // Then
      expect(result, Right(numberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(number));
    },
  );
}
