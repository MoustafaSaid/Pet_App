import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]) : super();
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
