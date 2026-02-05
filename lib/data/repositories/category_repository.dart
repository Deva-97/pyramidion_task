import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pyramidion_task/core/constants/api_constants.dart';
import 'package:pyramidion_task/core/network/api_service.dart';
import 'package:pyramidion_task/data/models/category_model.dart';

class CategoryRepository {
  final ApiService _apiService;
  static const String _cacheKey = 'categories_cache';
  CategoryRepository(this._apiService);

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.categoriesUrl);
      final List list = response['record']['categories'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(list));
      return list.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        final List<dynamic> list = jsonDecode(cached) as List<dynamic>;
        return list.map((json) => CategoryModel.fromJson(json)).toList();
      }
      rethrow;
    }
  }

  Future<CategoriesResult> fetchCategoriesWithSource() async {
    try {
      final response = await _apiService.get(ApiConstants.categoriesUrl);
      final List list = response['record']['categories'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(list));
      final items = list.map((json) => CategoryModel.fromJson(json)).toList();
      return CategoriesResult(items: items, usedCache: false);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null) {
        final List<dynamic> list = jsonDecode(cached) as List<dynamic>;
        final items = list.map((json) => CategoryModel.fromJson(json)).toList();
        return CategoriesResult(items: items, usedCache: true);
      }
      rethrow;
    }
  }
}

class CategoriesResult {
  final List<CategoryModel> items;
  final bool usedCache;

  CategoriesResult({required this.items, required this.usedCache});
}
