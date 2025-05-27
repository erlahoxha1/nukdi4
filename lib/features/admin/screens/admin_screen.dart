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

  List<Widget> pages = [
    const PostsScreen(),
    const AnalyticsScreen(),
    const Center(
      child: Text(
        'Cart Page',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // dark grey background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 9, 9), // dark red
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/applogo.png',
            width: 40,
            height: 40,
          ),
        ),
        actions: [
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
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'manage_categories',
                child: Text('Manage Categories'),
              ),
            ],
          ),
        ],
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: updatePage,
        backgroundColor: const Color.fromARGB(255, 104, 9, 9),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox_outlined),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
