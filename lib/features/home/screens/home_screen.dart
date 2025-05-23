import 'package:flutter/material.dart';
import 'package:nukdi4/features/home/screens/category_products_screen.dart';
import 'package:nukdi4/features/search/screens/filterscreen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToCategory(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: name)),
    );
  }

  void navigateToFilter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => FilterScreen(
              onApply: (filteredProducts) {
                // Handle filtered results if needed
                print('Filtered products: ${filteredProducts.length}');
              },
            ),
      ),
    );
  }

  final List<Map<String, dynamic>> categories = [
    {'name': 'Controller', 'icon': Icons.settings_remote},
    {'name': 'EV Charger', 'icon': Icons.electric_car},
    {'name': 'Motor', 'icon': Icons.motorcycle},
    {'name': 'Charger', 'icon': Icons.battery_charging_full},
    {'name': 'Battery', 'icon': Icons.battery_full},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: 10,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1976D2),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search part name",
                            border: InputBorder.none,
                          ),
                          onSubmitted: (query) {
                            // handle search
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Updated: "Product Categories" with filter icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Product Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: navigateToFilter,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () => navigateToCategory(category['name']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'],
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
