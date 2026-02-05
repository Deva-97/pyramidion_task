import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyramidion_task/core/network/api_service.dart';
import 'package:pyramidion_task/data/repositories/category_repository.dart';
import 'package:pyramidion_task/logic/category_provider.dart';
import 'package:pyramidion_task/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyTask());
}

class MyTask extends StatelessWidget {
  const MyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(
            CategoryRepository(ApiService()),
          )..fetchCategories(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Home Categories',
        home: const HomeScreen(),
      ),
    );
  }
}

