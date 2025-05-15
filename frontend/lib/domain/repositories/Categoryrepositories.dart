

import 'package:frontend/domain/entities/Categorymodel.dart';

abstract class Categoryrepositories {
  Future<List<Categorymodel>> getallCategory();
  Future<void> createCategory(String name, String description);
  Future<void> deleteCategory(String id);
  Future<Categorymodel> updateCategory(
      String id, String name, String description);
}
