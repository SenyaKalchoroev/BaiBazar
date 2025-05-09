import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'order_success_page.dart';
import '../providers/order_provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController cityController    = TextEditingController();
  final TextEditingController streetController  = TextEditingController();
  final TextEditingController houseController   = TextEditingController();
  final TextEditingController phoneController   = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    cityController.dispose();
    streetController.dispose();
    houseController.dispose();
    phoneController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.grey[300],
            shape: const CircleBorder(),
            child: IconButton(
              icon: SvgPicture.asset('assets/ic_arrow_back.svg', width: 24, height: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Оформление заказа',
          style: TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Город', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(
                controller: cityController,
                decoration: _inputDecoration(hint: 'Бишкек...'),
              ),
              const SizedBox(height: 12),

              const Text('Улица', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(
                controller: streetController,
                decoration: _inputDecoration(hint: 'Гагарина 100'),
              ),
              const SizedBox(height: 12),

              const Text('Дом/подъезд', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(
                controller: houseController,
                decoration: _inputDecoration(hint: '12А'),
              ),
              const SizedBox(height: 12),

              const Text('Номер телефона', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(hint: '+996xxxxxxx'),
              ),
              const SizedBox(height: 12),

              const Text('Комментарий к заказу', style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 6),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: _inputDecoration(hint: 'Напишите...'),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/ic_carefully.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Оплата только при получении товара',
                        style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/ic_truck.svg', width: 24, height: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Своя курьерская доставка',
                        style: TextStyle(fontFamily: 'Gilroy', fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF148A09),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: orderProv.isLoading
                      ? null
                      : () async {
                    await context.read<OrderProvider>().createOrder(
                      street: streetController.text,
                      homeAdress: houseController.text,
                      phonenumber: phoneController.text,
                      commentToOrder: commentController.text,
                    );
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderSuccessPage()),
                    );
                  },
                  child: orderProv.isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Заказать',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.local_shipping, color: Colors.white),
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

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFEBEBEB),
      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
