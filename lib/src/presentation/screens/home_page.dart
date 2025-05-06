import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:baibazar_app/src/presentation/providers/category_provider.dart';
import 'package:baibazar_app/src/presentation/providers/product_provider.dart';
import 'package:baibazar_app/src/presentation/widgets/category_item.dart';
import 'package:baibazar_app/src/presentation/widgets/product_card.dart';
import 'package:baibazar_app/src/presentation/screens/product_opened_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<CategoryProvider>().loadCategories();
      final categories = context.read<CategoryProvider>().categories;
      if (categories.isNotEmpty) {
        context.read<ProductProvider>().loadProductsByTag(categories.first.title);
      } else {
        context.read<ProductProvider>().loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider  = context.watch<ProductProvider>();
    final categories       = categoryProvider.categories;
    final products         = productProvider.products;
    final isLoadingCats    = categoryProvider.isLoading;
    final isLoadingProds   = productProvider.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Поиск
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => productProvider.searchProducts(v),
                  style: const TextStyle(color: Color(0xFF707070)),
                  decoration: InputDecoration(
                    hintText: 'Поиск',
                    hintStyle: const TextStyle(color: Color(0xFF808080)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset('assets/ic_search.svg', width: 24, height: 24),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFEBEBEB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Категории
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Категории',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                height: 106,
                child: isLoadingCats
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (ctx, i) {
                    final c = categories[i];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: () => productProvider.loadProductsByTag(c.title),
                        child: CategoryItem(
                          imageUrl: c.image,
                          title:    c.title,
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Продукты',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          productProvider.sortByNewest ? 'Новые' : 'Старые',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                          onPressed: productProvider.toggleSortByDate,
                          icon: SvgPicture.asset('assets/ic_filter_product.svg', width: 24, height: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isLoadingProds)
                const Center(child: CircularProgressIndicator())
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 120 / 168,
                  ),
                  itemBuilder: (ctx, i) {
                    final p = products[i];
                    final img = p.images.isNotEmpty ? p.images.first : '';
                    return ProductCard(
                      title:    p.title,
                      price:    '${p.price}c',
                      imageUrl: img,
                      onTap:    () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductOpenedPage(productId: p.id),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
