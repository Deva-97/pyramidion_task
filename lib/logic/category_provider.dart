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

  CategoryStatus get status => _status;
  List<CategoryModel> get categories => _categories;
  String get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _status = CategoryStatus.loading;
    notifyListeners();

    try{
      _categories = await _repository.fetchCategories();
      _status = CategoryStatus.success;
    }catch (e){
      _errorMessage = 'Unable to load categories';
      _status = CategoryStatus.error;
    }
    notifyListeners();
  }
}