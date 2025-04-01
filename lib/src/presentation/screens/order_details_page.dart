import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final List<Map<String, dynamic>> mockProducts = [
    {
      'title': 'Свежие огурцы',
      'priceKg': '80',
      'quantity': '1',
      'image': 'assets/img_products.png'
    },
    {
      'title': 'Свежие огурцы',
      'priceKg': '80',
      'quantity': '1',
      'image': 'assets/img_products.png'
    },
    {
      'title': 'Свежие огурцы',
      'priceKg': '80',
      'quantity': '1',
      'image': 'assets/img_products.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Детали заказа',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: mockProducts.length,
            itemBuilder: (context, index) {
              final product = mockProducts[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: product['image'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          product['image'],
                          fit: BoxFit.cover,
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Цена за кг: ${product['priceKg']}',
                            style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Количество: ${product['quantity']}',
                            style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.15,
            minChildSize: 0.15,
            maxChildSize: 0.45,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Ваш курьер',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Саид Горохов',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Телефон',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '+996 (550)-100-505',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Дата',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '30.01.25',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Статус',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'В процессе',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Цена за продукты',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '340c',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Цена за доставку',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '500c',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Итого',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '840c',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
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