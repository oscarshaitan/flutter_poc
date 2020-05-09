import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertest/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the strong reprecent an unsigned integer',
      () async {
        // Given
        final str = '123';
        // When
        final result = inputConverter.stringToUnsignedInteger(str);
        // Then
        expect(result, Right(123));
      },
    );

    test(
      'should return a failure when the string is not an integer',
      () async {
        // Given
        final str = 'abc';
        // When
        final result = inputConverter.stringToUnsignedInteger(str);
        // Then
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a failure when the string is a negative integer',
          () async {
        // Given
        final str = '-123';
        // When
        final result = inputConverter.stringToUnsignedInteger(str);
        // Then
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
