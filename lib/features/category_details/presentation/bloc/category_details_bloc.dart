import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_details_event.dart';
part 'category_details_state.dart';

class CategoryDetailsBloc extends Bloc<CategoryDetailsEvent, CategoryDetailsState> {
  CategoryDetailsBloc() : super(CategoryDetailsInitial()) {
    on<CategoryDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
