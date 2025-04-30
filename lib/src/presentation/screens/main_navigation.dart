import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_service.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'profile_authorized_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _current;
  bool _authorized = false;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final api = context.read<ApiService>();
    await api.init();
    if (api.isAuthorized) {
      try {
        await api.getProfile();
        if (mounted) setState(() => _authorized = true);
      } catch (_) {
        await api.clearToken();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomePage(),
      const CategoriesPage(),
      const CartPage(),
      _authorized ? const ProfileAuthorizedPage() : const ProfilePage(),
    ];

    return Scaffold(
      body: screens[_current],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _current,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (i) => setState(() => _current = i),
        items: [
          _item('assets/ic_home.svg', 'Главная'),
          _item('assets/ic_category.svg', 'Категории'),
          _item('assets/ic_cart.svg', 'Корзина'),
          _item('assets/ic_profile.svg', 'Профиль'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _item(String asset, String label) =>
      BottomNavigationBarItem(
        icon: SvgPicture.asset(asset, width: 24, height: 24),
        label: label,
      );
}
