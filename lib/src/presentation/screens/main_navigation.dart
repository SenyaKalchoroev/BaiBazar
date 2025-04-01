import 'package:baibazar_app/src/presentation/screens/profile_authorized_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  final _screens = const [
    HomePage(),
    CategoriesPage(),
    CartPage(),
    ProfilePage()
//    ProfileAuthorizedPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/ic_home.svg',
              width: 24,
              height: 24,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/ic_category.svg',
              width: 24,
              height: 24,
            ),
            label: 'Категории',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/ic_cart.svg',
              width: 24,
              height: 24,
            ),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/ic_profile.svg',
              width: 24,
              height: 24,
            ),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
