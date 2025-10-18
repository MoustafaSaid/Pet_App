import 'package:equatable/equatable.dart';

class HomeEvents extends Equatable {
  const HomeEvents();

  @override
  List<Object?> get props => [];
}

class GetBreedsEvent extends HomeEvents {
  final int page;
  final int limit;
  const GetBreedsEvent({required this.page, required this.limit});

  @override
  // TODO: implement props
  List<Object?> get props => [page, limit];
}
