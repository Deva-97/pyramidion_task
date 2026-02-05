import 'package:flutter/material.dart';
import 'package:pyramidion_task/data/models/category_model.dart';
import 'package:pyramidion_task/data/repositories/category_repository.dart';

enum CategoryStatus {initial, loading, success, error}

class CategoryProvider extends ChangeNotifier{
  final CategoryRepository _repository;
  CategoryProvider(this._repository);

  CategoryStatus _status = CategoryStatus.initial;
  List<CategoryModel> _categories = [];
  String _errorMessage = '';
  bool _usedCache = false;

  CategoryStatus get status => _status;
  List<CategoryModel> get categories => _categories;
  String get errorMessage => _errorMessage;
  bool get usedCache => _usedCache;

  Future<void> fetchCategories() async {
    _status = CategoryStatus.loading;
    _usedCache = false;
    notifyListeners();

    try{
      final result = await _repository.fetchCategoriesWithSource();
      _categories = result.items;
      _usedCache = result.usedCache;
      _status = CategoryStatus.success;
    }catch (e){
      _errorMessage = 'Unable to load categories';
      _status = CategoryStatus.error;
    }
    notifyListeners();
  }
}
