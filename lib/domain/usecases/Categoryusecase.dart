import 'package:frontend/domain/entities/Categoryentities.dart';
import 'package:frontend/domain/repositories/Categoryrepositories.dart';

class Categoryusecase {
  final Categoryrepositories categoryRepository;

  Categoryusecase({required this.categoryRepository});

  Future<void> createCategory(String name, String description) {
    return categoryRepository.createCategory(name, description);
  }

  Future<List<Categoryentities>> getallCategory() {
    return categoryRepository.getallCategory();
  }

  Future<void> deleteCategory(String id) {
    return categoryRepository.deleteCategory(id);
  }

  Future<Categoryentities> updateCategory(String id, String name, String description) {
    return categoryRepository.updateCategory(id, name, description);
  }
}
