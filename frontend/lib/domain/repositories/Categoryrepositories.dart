

import 'package:frontend/domain/entities/Categoryentities.dart';

abstract class Categoryrepositories {
  Future<List<Categoryentities>> getallCategory();
  Future<void> createCategory(String name, String description);
  Future<void> deleteCategory(String id);
  Future<Categoryentities> updateCategory(
      String id, String name, String description);
}
