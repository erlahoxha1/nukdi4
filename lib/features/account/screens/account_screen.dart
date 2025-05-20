import 'package:flutter/material.dart';
import 'package:nukdi4/features/account/screens/orders_screen.dart';
import 'package:nukdi4/features/account/screens/profile_screen.dart';
import 'package:nukdi4/features/account/services/account_services.dart';
import 'package:nukdi4/features/order_details/screens/order_details.dart';
import 'package:nukdi4/features/account/screens/profile_screen.dart';
import 'package:nukdi4/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nukdi4/features/auth/screens/auth_screen.dart';
// ... (your existing imports)
import 'package:nukdi4/features/account/screens/add_address_screen.dart'; // <-- NEW

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Hello, ${user.name.toLowerCase()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            _buildProfileTile(
              context,
              icon: Icons.shopping_bag_outlined,
              label: 'View Your Orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildProfileTile(
              context,
              icon: Icons.person_outline,
              label: 'My Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildProfileTile(
              context,
              icon: Icons.location_on_outlined,
              label: 'Add Address',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAddressScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildProfileTile(
              context,
              icon: Icons.logout,
              label: 'Log Out',
              iconColor: Colors.redAccent,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('x-auth-token');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AuthScreen.routeName,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.blue,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
