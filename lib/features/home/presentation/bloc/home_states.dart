import 'package:equatable/equatable.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeStates extends Equatable {
  final HomeStatus status;
  final List<BreedEntity> breeds;
  final String errorMessage;
  const HomeStates({
    this.status = HomeStatus.initial,
    this.breeds = const [],
    this.errorMessage = '',
  });

  HomeStates copyWith({
    HomeStatus? status,
    List<BreedEntity>? breeds,
    String? errorMessage,
  }) {
    return HomeStates(
      status: status ?? this.status,
      breeds: breeds ?? this.breeds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, breeds, errorMessage];
}
