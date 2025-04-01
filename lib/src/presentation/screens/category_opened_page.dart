import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:baibazar_app/src/data/models/category_model.dart';
import 'package:baibazar_app/src/presentation/providers/product_provider.dart';
import 'package:baibazar_app/src/presentation/screens/product_opened_page.dart';
import 'package:baibazar_app/src/presentation/widgets/product_card.dart';

class CategoryOpenedPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryOpenedPage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryOpenedPage> createState() => _CategoryOpenedPageState();
}

class _CategoryOpenedPageState extends State<CategoryOpenedPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().loadProductsByTag(widget.category.title);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;
    final isLoading = productProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.grey[300],
            shape: const CircleBorder(),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/ic_arrow_back.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Каталог',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    productProvider.searchProducts(value);
                  },
                  style: const TextStyle(color: Color(0xFF707070)),
                  decoration: InputDecoration(
                    hintText: 'Поиск',
                    hintStyle: const TextStyle(color: Color(0xFF808080)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/ic_search.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    fillColor: const Color(0xFFEBEBEB),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      widget.category.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Продукты',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                          onPressed: () {
                            productProvider.toggleSortByDate();
                          },
                          icon: SvgPicture.asset(
                            'assets/ic_filter_product.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 152 / 188,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl =
                    product.images.isNotEmpty ? product.images.first : '';
                    return ProductCard(
                      title: product.title,
                      price: '${product.price}c',
                      imageUrl: imageUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductOpenedPage(productId: product.id),
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
