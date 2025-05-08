// lib/src/presentation/screens/main_navigation.dart

import 'package:easy_localization/easy_localization.dart';
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

    final items = <_NavItem>[
      _NavItem(icon: 'assets/ic_home.svg',      label: tr('home')),
      _NavItem(icon: 'assets/ic_category.svg',  label: tr('categories')),
      _NavItem(icon: 'assets/ic_cart.svg',      label: tr('cart')),
      _NavItem(icon: 'assets/ic_profile.svg',   label: tr('profile')),
    ];

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: false,
        child: screens[_current],
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == _current;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _current = i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        item.icon,
                        width: 24,
                        height: 24,
                        color: Colors.green
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 46,
                        height: 2,
                        decoration: BoxDecoration(
                          color: selected ? Colors.green : Colors.transparent,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
