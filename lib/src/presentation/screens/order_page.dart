import 'package:baibazar_app/src/presentation/screens/order_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController cityController = TextEditingController(text: 'Бишкек...');
  final TextEditingController streetController = TextEditingController(text: 'Гагарина 100');
  final TextEditingController houseController = TextEditingController(text: 'Бишкек...');
  final TextEditingController phoneController = TextEditingController(text: '+996xxxxxx');
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          'Оформление заказа',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Город',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: 'Бишкек...',
                  filled: true,
                  fillColor: const Color(0xFFEBEBEB),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Улица',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: streetController,
                decoration: InputDecoration(
                  hintText: 'Гагарина 100',
                  filled: true,
                  fillColor: const Color(0xFFEBEBEB),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Дом/подъезд',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: houseController,
                decoration: InputDecoration(
                  hintText: 'Бишкек...',
                  filled: true,
                  fillColor: const Color(0xFFEBEBEB),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Номер телефона',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+996xxxxxx',
                  filled: true,
                  fillColor: const Color(0xFFEBEBEB),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Комментарий к заказу',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Напишите...',
                  filled: true,
                  fillColor: const Color(0xFFEBEBEB),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/ic_carefully.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Оплата только при получении товара',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/ic_truck.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Своя курьерская доставка',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF148A09),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:(_)=>
                      const OrderSuccessPage())
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Заказать',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/ic_truck.svg',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
