import 'package:frontend/data/datasources/Categorydatasource.dart';
import 'package:frontend/domain/entities/Categoryentities.dart';
import 'package:frontend/domain/repositories/Categoryrepositories.dart';

class Categoryrepositoriesimpl implements Categoryrepositories {
  final CategoryDataSource categoryDataSource;
  Categoryrepositoriesimpl({required this.categoryDataSource});
  @override
  Future<List<Categoryentities>> getallCategory() async {
    return await categoryDataSource.getAllCategory();
  }

  @override
  Future<void> createCategory(String name, String description) async {
    return await categoryDataSource.createCategory(name, description);
  }

  @override
  Future<void> deleteCategory(String id) async {
    return await categoryDataSource.deleteCategory(id);
  }

  @override
  Future<Categoryentities> updateCategory(
      String id, String name, String description) async {
    return await categoryDataSource.updateCategory(id, name, description);
  }
}
