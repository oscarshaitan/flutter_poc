import 'package:dartz/dartz.dart';
import 'package:fluttertest/core/error/failures.dart';
import 'package:fluttertest/features/cat_breeds/domain/entities/breed_details.dart';
import 'package:fluttertest/features/cat_breeds/domain/entities/cat_breeds.dart';

abstract class CatBreedsRepository {
  Future<Either<Failure, List<CatBreeds>>> getCatBreeds();

  Future<Either<Failure, BreedDetails>> getBreedDetails(String breedId);
}

