import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'craftsman_profile_event.dart';
part 'craftsman_profile_state.dart';

class CraftsmanProfileBloc extends Bloc<CraftsmanProfileEvent, CraftsmanProfileState> {
  CraftsmanProfileBloc() : super(CraftsmanProfileInitial()) {
    on<CraftsmanProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
