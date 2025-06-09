import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/category_model.dart';

abstract class CategoryEvent {}

class FetchCategoriesEvent extends CategoryEvent {}

class SearchCategoryEvent extends CategoryEvent {
  final String query;
  SearchCategoryEvent(this.query);
}

class EditCategoryEvent extends CategoryEvent {
  final int categoryId;
  final String name;
  final String description;

  EditCategoryEvent({required this.categoryId, required this.name, required this.description});
}

class DeleteCategoryEvent extends CategoryEvent {
  final int categoryId;
  DeleteCategoryEvent(this.categoryId);
}
abstract class CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> categories;
  CategoryLoadedState(this.categories);
}

class CategoryErrorState extends CategoryState {
  final String message;
  CategoryErrorState(this.message);
}


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  List<CategoryModel> _allCategories = [
    CategoryModel(categoryId: 1, name: 'Books', description: 'Reading materials'),
    CategoryModel(categoryId: 2, name: 'Work', description: 'Work-related stuff'),
    // Add more dummy categories if needed
  ];

  CategoryBloc() : super(CategoryLoadingState()) {
    on<FetchCategoriesEvent>((event, emit) {
      emit(CategoryLoadedState(List.from(_allCategories)));
    });

    on<SearchCategoryEvent>((event, emit) {
      final results = _allCategories.where((c) =>
          c.name.toLowerCase().contains(event.query.toLowerCase())
      ).toList();
      emit(CategoryLoadedState(results));
    });

    on<EditCategoryEvent>((event, emit) {
      final index = _allCategories.indexWhere((c) => c.categoryId == event.categoryId);
      if (index != -1) {
        _allCategories[index] = CategoryModel(
          categoryId: event.categoryId,
          name: event.name,
          description: event.description,
        );
      }
      emit(CategoryLoadedState(List.from(_allCategories)));
    });

    on<DeleteCategoryEvent>((event, emit) {
      _allCategories.removeWhere((c) => c.categoryId == event.categoryId);
      emit(CategoryLoadedState(List.from(_allCategories)));
    });
  }
}
