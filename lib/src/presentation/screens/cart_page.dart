import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:baibazar_app/src/presentation/widgets/cart_item.dart';
import 'package:baibazar_app/src/presentation/screens/main_navigation.dart';
import 'package:baibazar_app/src/presentation/screens/order_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, String>> mockCart = [
    {
      'image': 'assets/img_products.png',
      'title': 'Яблоки',
      'weight': '2кг',
      'price': '200c'
    },
    {
      'image': 'assets/img_products.png',
      'title': 'Картофель',
      'weight': '3кг',
      'price': '150c'
    },
  ];

  bool get isEmptyCart => mockCart.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isEmptyCart
          ? Stack(
        children: [
          Positioned(
            top: 160,
            left: 73,
            child: Image.asset(
              'assets/img_empty_cart.png',
              width: 214,
              height: 214,
            ),
          ),
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  'Корзина Пуста',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.25,
                    letterSpacing: 0.25,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Для того, чтобы оформить заказ, вам\nнеобходимо выбрать продукт из \nкатегорий и добавить в корзину',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xFF919191),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.4,
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF148A09),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(initialIndex: 1),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'В категории',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/ic_category.svg',
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
      )
          : Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: const Text(
                      'Корзина',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: mockCart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = mockCart[index];
                      return CartItemWidget(
                        image: item['image'] ?? '',
                        title: item['title'] ?? '',
                        weight: item['weight'] ?? '',
                        price: item['price'] ?? '',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.05,
            minChildSize: 0.05,
            maxChildSize: 0.35,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
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
                              children: const [
                                Text(
                                  'Цена за продукты',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '350c',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Цена за доставку',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '50c',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
                              children: const [
                                Text(
                                  'Итого к оплате',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '400c',
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const OrderPage(),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
