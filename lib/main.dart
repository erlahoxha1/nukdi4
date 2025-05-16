import 'package:nukdi2/features/admin/screens/admin_screen.dart';
import 'package:nukdi2/features/home/screens/home_screens.dart';
import 'package:provider/provider.dart';
import 'package:nukdi2/provider/user_provider.dart'; // ✅ This fixes your error
import 'package:flutter/material.dart';
import 'package:nukdi2/constants/global_variables.dart';
import 'package:nukdi2/router.dart';
import 'package:nukdi2/features/auth/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:nukdi2/features/auth/services/auth_service.dart';
import 'package:nukdi2/common/widgets/bottom_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'carapp',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home:
          Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? Provider.of<UserProvider>(context).user.type == 'user'
                  ? const BottomBar()
                  : const AdminScreen()
              : const AuthScreen(),
    );
  }
}
