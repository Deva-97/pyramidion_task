// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pyramidion_task/core/network/api_service.dart';
import 'package:pyramidion_task/data/models/category_model.dart';
import 'package:pyramidion_task/data/repositories/category_repository.dart';
import 'package:pyramidion_task/logic/category_provider.dart';
import 'package:pyramidion_task/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders categories from provider',
      (WidgetTester tester) async {
    final provider = CategoryProvider(_FakeRepository());
    await provider.fetchCategories();

    await tester.pumpWidget(
      ChangeNotifierProvider<CategoryProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Shop by Categories'), findsOneWidget);
    expect(find.text('Chair'), findsOneWidget);
  });
}

class _FakeRepository extends CategoryRepository {
  _FakeRepository() : super(ApiService());

  @override
  Future<CategoriesResult> fetchCategoriesWithSource() async {
    return CategoriesResult(
      usedCache: false,
      items: [
        CategoryModel(
          id: '1',
          name: 'Chair',
          imageUrl: '',
        ),
      ],
    );
  }
}
