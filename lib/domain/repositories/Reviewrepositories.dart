

import 'package:frontend/domain/entities/Reviewentities.dart';

abstract class Reviewrepositories {
    Future<void> createRating(
  String  paperId, String? userId, String? rating,String comment);
  Future<List<Reviewentities>> getallRating();
}