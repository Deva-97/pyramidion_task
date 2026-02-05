import 'package:flutter_test/flutter_test.dart';
import 'package:pyramidion_task/core/network/api_service.dart';
import 'package:pyramidion_task/data/models/category_model.dart';
import 'package:pyramidion_task/data/repositories/category_repository.dart';
import 'package:pyramidion_task/logic/category_provider.dart';

class TestCategoryRepository extends CategoryRepository {
  final CategoriesResult? result;
  final Exception? exception;

  TestCategoryRepository.success(this.result)
      : exception = null,
        super(ApiService());

  TestCategoryRepository.failure(this.exception)
      : result = null,
        super(ApiService());

  @override
  Future<CategoriesResult> fetchCategoriesWithSource() async {
    if (exception != null) {
      throw exception!;
    }
    return result!;
  }
}

void main() {
  group('CategoryProvider', () {
    test('sets success state and cache flag', () async {
      final repo = TestCategoryRepository.success(
        CategoriesResult(
          items: [
            CategoryModel(
              id: '1',
              name: 'Chair',
              imageUrl: 'https://example.com/chair.png',
            ),
          ],
          usedCache: true,
        ),
      );
      final provider = CategoryProvider(repo);

      await provider.fetchCategories();

      expect(provider.status, CategoryStatus.success);
      expect(provider.categories.length, 1);
      expect(provider.usedCache, isTrue);
    });

    test('sets error state when repository throws', () async {
      final repo = TestCategoryRepository.failure(Exception('fail'));
      final provider = CategoryProvider(repo);

      await provider.fetchCategories();

      expect(provider.status, CategoryStatus.error);
      expect(provider.errorMessage, isNotEmpty);
    });
  });
}
