import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:nukdi4/constants/global_variables.dart';
import 'package:nukdi4/features/admin/screens/posts_screen.dart';
import 'package:nukdi4/features/admin/screens/analtyics_screen.dart';
import 'package:nukdi4/features/admin/screens/manage_categories_screen.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin-screen';
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PostsScreen(),
    const Center(child: Text('Analytics Page')),
    const Center(child: Text('Cart Page')),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  Widget buildNavIcon(IconData icon, int index) {
    return Container(
      width: bottomBarWidth,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color:
                _page == index
                    ? GlobalVariables.selectedNavBarColor
                    : GlobalVariables.backgroundColor,
            width: bottomBarBorderWidth,
          ),
        ),
      ),
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/applogo.png',
                  width: 50,
                  height: 100,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Admin Panel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'manage_categories') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageCategoriesScreen(),
                      ),
                    );
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'manage_categories',
                        child: Text('Manage Categories'),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
            icon: buildNavIcon(Icons.home_outlined, 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(Icons.analytics_outlined, 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(Icons.all_inbox_outlined, 2),
            label: '',
          ),
        ],
      ),
    );
  }
}
