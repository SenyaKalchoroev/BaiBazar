import 'package:baibazar_app/src/presentation/screens/my_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:baibazar_app/src/presentation/screens/main_navigation.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img_success_order.png',
                  width: 214,
                  height: 214,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ваш заказ готовится',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.25,
                    letterSpacing: 0.25,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Для того, чтобы узнать информацию\nо курьере и о статусе заказа, перейдите на\nстраницу «Мои заказы», в разделе - Профиль',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 24),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyOrdersPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Мои заказы',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF148A09)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigation(initialIndex: 0),
                        ),
                      );
                    },
                    child: const Text(
                      'Главная',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF148A09),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
