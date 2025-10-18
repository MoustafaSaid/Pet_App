import 'package:pet_app/features/home/domain/use_cases/get_breeds.dart';
import 'package:pet_app/features/home/presentation/bloc/home_events.dart';
import 'package:pet_app/features/home/presentation/bloc/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  GetBreedsUseCase getBreedsUseCase;
  HomeBloc({required this.getBreedsUseCase})
    : super(HomeStates(status: HomeStatus.initial)) {
    on<GetBreedsEvent>((event, emit) async {
      emit(state.copyWith(status: HomeStatus.loading));
      var result = await getBreedsUseCase(
        Params(page: event.page, limit: event.limit),
      );
      result.fold(
        (l) {
          emit(
            state.copyWith(
              status: HomeStatus.error,
              errorMessage: l.toString(),
            ),
          );
        },
        (r) {
          emit(state.copyWith(status: HomeStatus.loaded, breeds: r));
        },
      );
    });
  }
}
