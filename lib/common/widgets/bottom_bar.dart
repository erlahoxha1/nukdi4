import 'package:flutter/material.dart';
import 'package:nukdi2/constants/global_variables.dart';
import 'package:badges/badges.dart' as badges;
import 'package:nukdi2/features/account/screens/account_screen.dart';
import 'package:nukdi2/features/home/screens/home_screens.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const Center(child: Text('Cart Page')),
  ];
  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //homepage
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,

              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _page == 0
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.home_outlined),
            ),
            label: '',
          ), //acount
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,

              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _page == 1
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(Icons.person_outline_outlined),
            ),
            label: '',
          ),

          //Cart
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _page == 2
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: badges.Badge(
                badgeStyle: badges.BadgeStyle(
                  elevation: 0,
                  badgeColor: Colors.white,
                ),
                badgeContent: const Text('2'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
