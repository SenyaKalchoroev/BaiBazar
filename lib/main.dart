import 'package:baibazar_app/src/presentation/screens/splash_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'src/core/api/api_service.dart';
import 'src/data/repositories/category_repository.dart';
import 'src/data/repositories/products_repository.dart';
import 'src/data/repositories/cart_repository.dart';
import 'src/data/repositories/order_repository.dart';
import 'src/presentation/providers/category_provider.dart';
import 'src/presentation/providers/product_provider.dart';
import 'src/presentation/providers/cart_provider.dart';
import 'src/presentation/providers/order_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs     = await SharedPreferences.getInstance();
  final savedCode = prefs.getString('locale') ?? 'ru';

  final apiService = ApiService();
  await apiService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ru'), Locale('ky')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      startLocale: Locale(savedCode),
      child: MyApp(apiService: apiService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  const MyApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),

        ProxyProvider<ApiService, CategoryRepository>(
          update: (_, api, __) => CategoryRepository(apiService: api),
        ),
        ChangeNotifierProxyProvider<CategoryRepository, CategoryProvider>(
          create: (_) => CategoryProvider(
            repository: CategoryRepository(apiService: apiService),
          ),
          update: (_, repo, __) => CategoryProvider(repository: repo),
        ),

        ProxyProvider<ApiService, ProductRepository>(
          update: (_, api, __) => ProductRepository(apiService: api),
        ),
        ChangeNotifierProxyProvider<ProductRepository, ProductProvider>(
          create: (_) => ProductProvider(
            repository: ProductRepository(apiService: apiService),
          ),
          update: (_, repo, __) => ProductProvider(repository: repo),
        ),

        ChangeNotifierProvider<CartProvider>(
          create: (ctx) => CartProvider(CartRepository(ctx.read<ApiService>())),
        ),

        ProxyProvider<ApiService, OrderRepository>(
          update: (_, api, __) => OrderRepository(api),
        ),
        ChangeNotifierProxyProvider<OrderRepository, OrderProvider>(
          create: (ctx) => OrderProvider(ctx.read<OrderRepository>()),
          update: (_, repo, __) => OrderProvider(repo),
        ),
      ],
      child: MaterialApp(
        title: 'Baibazar App',
        debugShowCheckedModeBanner: false,

        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,

        theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        home: const SplashScreen(),
      ),
    );
  }
}
