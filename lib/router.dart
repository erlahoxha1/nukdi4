import 'package:flutter/material.dart';
import 'package:nukdi2/features/admin/screens/add_product_screen.dart';
import 'package:nukdi2/features/auth/screens/auth_screen.dart';
import 'package:nukdi2/features/home/screens/category_deals_screen.dart';
import 'package:nukdi2/features/home/screens/home_screens.dart';
import 'package:nukdi2/common/widgets/bottom_bar.dart';
import 'package:nukdi2/features/admin/screens/admin_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case CategoryDealsScreen.routeName:
    var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  CategoryDealsScreen(
          category: category,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(body: Center(child: Text('no exist'))),
      );
  }
}
