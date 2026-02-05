import 'package:pyramidion_task/core/constants/api_constants.dart';
import 'package:pyramidion_task/core/network/api_service.dart';
import 'package:pyramidion_task/data/models/category_model.dart';

class CategoryRepository {
  final ApiService _apiService;
  CategoryRepository(this._apiService);

  Future <List<CategoryModel>> fetchCategories() async {
    final response = await _apiService.get(ApiConstants.categoriesUrl);
    final List list = response['record']['categories'];
    return list.map((json) => CategoryModel.fromJson(json)).toList();
  } 
}