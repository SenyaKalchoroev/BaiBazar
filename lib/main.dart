import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/core/api/api_service.dart';
import 'src/data/repositories/category_repository.dart';
import 'src/data/repositories/products_repository.dart';
import 'src/presentation/providers/category_provider.dart';
import 'src/presentation/providers/product_provider.dart';
import 'src/presentation/screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  await apiService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),

        ProxyProvider<ApiService, CategoryRepository>(
          update: (_, api, __) => CategoryRepository(apiService: api),
        ),
        ProxyProvider<ApiService, ProductRepository>(
          update: (_, api, __) => ProductRepository(apiService: api),
        ),

        ChangeNotifierProxyProvider<CategoryRepository, CategoryProvider>(
          create: (_) =>
              CategoryProvider(repository: CategoryRepository(apiService: apiService)),
          update: (_, repo, __) => CategoryProvider(repository: repo),
        ),
        ChangeNotifierProxyProvider<ProductRepository, ProductProvider>(
          create: (_) =>
              ProductProvider(repository: ProductRepository(apiService: apiService)),
          update: (_, repo, __) => ProductProvider(repository: repo),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baibazar App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MainNavigation(),
    );
  }
}
