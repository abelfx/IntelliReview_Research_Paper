import 'package:frontend/domain/entities/Categoryentities.dart';

class Categoryusecase {
  final Categoryusecase categoryusecase; 

 Categoryusecase({required this.categoryusecase});

  Future<void> createCategory(String name, String description) async {
    return await categoryusecase.createCategory(name, description);
  }

  Future<List<Categoryentities>> getallCategory() async {
    return await categoryusecase.getallCategory();
  }  

 Future<void> deleteCategory(String id) async {
    return await categoryusecase.deleteCategory(id);
  }

    Future<Categoryentities> updateCategory(
      String id, String name, String description) async {
    return await categoryusecase.updateCategory(id, name, description);
  }
}
