import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pyramidion_task/data/repositories/category_repository.dart';
import 'package:pyramidion_task/core/network/api_service.dart';

class FakeApiService extends ApiService {
  final Map<String, dynamic>? response;
  final bool shouldThrow;

  FakeApiService.success(this.response) : shouldThrow = false;
  FakeApiService.failure()
      : response = null,
        shouldThrow = true;

  @override
  Future<Map<String, dynamic>> get(String url) async {
    if (shouldThrow) {
      throw Exception('network error');
    }
    return response!;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CategoryRepository', () {
    test('fetchCategoriesWithSource returns API data and caches it', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = CategoryRepository(
        FakeApiService.success({
          'record': {
            'categories': [
              {
                'id': '1',
                'name': 'Chair',
                'image': 'https://example.com/chair.png',
              },
            ],
          },
        }),
      );

      final result = await repo.fetchCategoriesWithSource();

      expect(result.usedCache, isFalse);
      expect(result.items.length, 1);
      expect(result.items.first.name, 'Chair');

      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('categories_cache');
      expect(cached, isNotNull);
      final List<dynamic> decoded = jsonDecode(cached!) as List<dynamic>;
      expect(decoded.length, 1);
    });

    test('fetchCategoriesWithSource uses cache when network fails', () async {
      final cachedList = [
        {
          'id': '2',
          'name': 'Sofa',
          'image': 'https://example.com/sofa.png',
        }
      ];
      SharedPreferences.setMockInitialValues({
        'categories_cache': jsonEncode(cachedList),
      });

      final repo = CategoryRepository(FakeApiService.failure());
      final result = await repo.fetchCategoriesWithSource();

      expect(result.usedCache, isTrue);
      expect(result.items.length, 1);
      expect(result.items.first.name, 'Sofa');
    });
  });
}
