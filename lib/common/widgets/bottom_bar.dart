import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/features/account/screens/account_screen.dart';
import 'package:nukdi4/features/cart/screens/cart_screen.dart';
import 'package:nukdi4/features/home/screens/home_screen.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 4;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: const Color(0xFF1C1C1E), // dark gray background
        iconSize: 28,
        onTap: updatePage,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavItem(Icons.home_outlined, 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(Icons.person_outline_outlined, 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Text(
                userCartLen.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                elevation: 0,
                badgeColor: Colors.white,
              ),
              child: _buildNavItem(Icons.shopping_cart_outlined, 2),
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Container(
      width: bottomBarWidth,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                _page == index
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.transparent,
            width: bottomBarBorderWidth,
          ),
        ),
      ),
      child: Icon(icon),
    );
  }
}
