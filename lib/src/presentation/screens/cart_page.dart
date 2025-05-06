// lib/src/presentation/screens/cart_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cart_model.dart';
import '../widgets/cart_item.dart';
import '../widgets/empty_cart_screen.dart';
import '../providers/cart_provider.dart';
import 'order_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CartProvider>().loadCart());
  }

  void _confirmRemove(CartItemModel item) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Удалить товар из корзины?'),
            content: Text(item.title),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<CartProvider>().removeFromCart(item.id);
                },
                child: const Text('Удалить'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (cart.items.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: EmptyCartScreen(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Корзина',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = cart.items[i];
                      return CartItemWidget(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        weight: item.weight,
                        price: item.price,
                        onRemove: () => _confirmRemove(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.05,
              minChildSize: 0.05,
              maxChildSize: 0.35,
              builder:
                  (ctx, scroll) => Material(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      side: BorderSide(color: Color(0xFFE0E0E0), width: 0.4),
                    ),
                    color: Colors.white, // #FFFFFF
                    child: SingleChildScrollView(
                      controller: scroll,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Цена за продукты'),
                                    Text(
                                      '${cart.fullPrice}c',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Цена за доставку'),
                                    Text(
                                      '50c',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(thickness: 1),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Итого'),
                                    Text(
                                      '${(cart.fullPrice + 50).toStringAsFixed(2)}c',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF148A09),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const OrderPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Оформить заказ',
                                      style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
