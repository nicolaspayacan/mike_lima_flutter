import 'package:dartz/dartz.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}