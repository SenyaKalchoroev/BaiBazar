// lib/src/presentation/screens/category_opened_page.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:baibazar_app/src/data/models/category_model.dart';
import 'package:baibazar_app/src/presentation/providers/product_provider.dart';
import 'package:baibazar_app/src/presentation/screens/product_opened_page.dart';
import 'package:baibazar_app/src/presentation/widgets/product_card.dart';

class CategoryOpenedPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryOpenedPage({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryOpenedPage> createState() => _CategoryOpenedPageState();
}

class _CategoryOpenedPageState extends State<CategoryOpenedPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<ProductProvider>()
          .loadProductsByTag(widget.category.title);
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
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Material(
                    color: Colors.grey[300],
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          'assets/ic_arrow_back.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _searchController,
                        onChanged: productProvider.searchProducts,
                        decoration: InputDecoration(
                          hintText: 'Поиск',
                          hintStyle:
                          const TextStyle(color: Color(0xFF808080)),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/ic_search.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(top: 10, bottom: 0),
                          filled: true,
                          fillColor: const Color(0xFFEBEBEB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Color(0xFF707070)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.category.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'products',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                fontWeight: FontWeight.bold),
                          ).tr(),
                          Row(
                            children: [
                              Text(
                                productProvider.sortByNewest
                                    ? 'new'.tr()
                                    : 'old'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                    fontWeight:
                                    FontWeight.w600),
                              ),
                              IconButton(
                                onPressed: productProvider
                                    .toggleSortByDate,
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
                      const Center(
                          child: CircularProgressIndicator())
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 152 / 188,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final imageUrl = product.images.isNotEmpty
                              ? product.images.first
                              : '';
                          return ProductCard(
                            title: product.title,
                            price: '${product.price}c',
                            imageUrl: imageUrl,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductOpenedPage(
                                          productId:
                                          product.id),
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
          ],
        ),
      ),
    );
  }
}
