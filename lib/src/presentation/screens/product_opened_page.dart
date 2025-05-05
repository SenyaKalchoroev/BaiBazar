import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:baibazar_app/src/presentation/providers/product_provider.dart';
import 'package:baibazar_app/src/data/models/product_model.dart';
import 'package:baibazar_app/src/presentation/screens/cart_page.dart';

import '../providers/cart_provider.dart';

class ProductOpenedPage extends StatefulWidget {
  final int productId;

  const ProductOpenedPage({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductOpenedPage> createState() => _ProductOpenedPageState();
}

class _ProductOpenedPageState extends State<ProductOpenedPage> {
  final TextEditingController _quantityController =
  TextEditingController(text: '1кг');
  int _currentPage = 0;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().loadSingleProduct(widget.productId);
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final isLoading = productProvider.isLoadingSingle;
    final error = productProvider.singleProductError;
    final product = productProvider.selectedProduct;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Color(0xFEFEFEF),
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
          'О продукте',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Text(error))
            : product == null
            ? const Center(child: Text('Нет данных о продукте'))
            : _buildContent(context, product),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProductModel product) {
    final images = product.images;
    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final imageUrl = images[index];
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_currentPage + 1}/${images.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.only(left: 20, top: 16, right: 16, bottom: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                product.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Укажите количество',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Цена за 1кг',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.only(left: 20, right: 16, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 180,
                  height: 36,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '1кг',
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: const Color(0xFFEBEBEB),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Text(
                  '${product.price}c',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Divider(
              color: Color(0xFFEBEBEB),
              thickness: 1,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Описание',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDescriptionText(product.description),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF148A09),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await context.read<CartProvider>().addToCart(widget.productId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'В корзину',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/ic_cart.svg',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText(String description) {
    const maxLinesCollapsed = 3;

    if (_isDescriptionExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style:
            const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () =>
                setState(() => _isDescriptionExpanded = false),
            child: const Text(
              'Скрыть',
              style: TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    } else {
      final textSpan = TextSpan(text: description);
      final textPainter = TextPainter(
        text: textSpan,
        maxLines: maxLinesCollapsed,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        maxWidth: MediaQuery.of(context).size.width - 32,
      );

      if (textPainter.didExceedMaxLines) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              maxLines: maxLinesCollapsed,
              overflow: TextOverflow.ellipsis,
              style:
              const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () =>
                  setState(() => _isDescriptionExpanded = true),
              child: const Text(
                'Показать ещё',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      } else {
        return Text(
          description,
          style:
          const TextStyle(fontSize: 14, color: Colors.black54),
        );
      }
    }
  }
}
