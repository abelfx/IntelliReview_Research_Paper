import 'package:frontend/application/providers/category_provider.dart';
import 'package:frontend/domain/entities/Categoryentities.dart';
import 'package:frontend/domain/usecases/Categoryusecase.dart';
import 'package:riverpod/riverpod.dart';

class CategoryNotifier
    extends StateNotifier<AsyncValue<List<Categoryentities>>> {
  final Categoryusecase categoryUseCase;

  CategoryNotifier(this.categoryUseCase) : super(const AsyncLoading()) {
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    try {
      final categories = await categoryUseCase.getallCategory();
      state = AsyncData(categories);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addCategory(String name, String description) async {
    try {
      await categoryUseCase.createCategory(name, description);
      await getAllCategories();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeCategory(String id) async {
    try {
      await categoryUseCase.deleteCategory(id);
      await getAllCategories();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> editCategory(String id, String name, String description) async {
    try {
      await categoryUseCase.updateCategory(id, name, description);
      await getAllCategories();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<Categoryentities>>>(
        (ref) {
  final useCase = ref.watch(categoryUseCaseProvider);
  return CategoryNotifier(useCase);
});
