import 'package:dartz/dartz.dart';

extension SomeEitherExtension<L, R> on Option<Either<L, R>> {
  B foldDefaultRight<B>(B Function(L l) ifLeft, B Function() ifRight) {
    return fold(
        () => ifRight(), (a) => a.fold((l) => ifLeft(l), (r) => ifRight()));
  }

  B foldDefaultLeft<B>(B Function() ifLeft, B Function(R r) ifRight) {
    return fold(
        () => ifLeft(), (a) => a.fold((l) => ifLeft(), (r) => ifRight(r)));
  }
}
