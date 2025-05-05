import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:baibazar_app/src/presentation/screens/main_navigation.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext c) {
    return Stack(
      children: [
        const Positioned(
          top: 160, left: 73,
          child: Image(
            image: AssetImage('assets/img_empty_cart.png'),
            width: 214, height: 214,
          ),
        ),
        Positioned(
          top: 400, left: 0, right: 0,
          child: Column(
            children: const [
              Text(
                'Корзина Пуста',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    fontSize: 16, height: 1.25, letterSpacing: 0.25
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
                    fontSize: 14, height: 1.4, letterSpacing: 0.25
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 40, left: 20, right: 20,
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
                  c,
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
                    width: 24, height: 24, color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
