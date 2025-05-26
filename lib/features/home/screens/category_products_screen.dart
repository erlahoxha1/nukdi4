import 'package:flutter/material.dart';
import 'package:nukdi4/features/home/services/home_services.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/common/widgets/loader.dart';
import 'package:nukdi4/features/product_details/screens/product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product>? products;
  List<Product> displayedProducts = [];

  final HomeServices homeServices = HomeServices();

  String selectedSort = 'Name A-Z';

  Set<String> selectedNames = {};
  Set<String> selectedBrands = {};
  Set<String> selectedModels = {};
  Set<String> selectedYears = {};

  RangeValues priceRange = const RangeValues(0, 10000);

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    products = await homeServices.fetchCategoryProducts(
      context: context,
      categoryId: widget.categoryId,
    );
    applyFilters();
  }

  void applyFilters() {
    if (products == null) return;

    displayedProducts =
        products!.where((p) {
          final matchesName =
              selectedNames.isEmpty || selectedNames.contains(p.name);
          final matchesBrand =
              selectedBrands.isEmpty || selectedBrands.contains(p.carBrand);
          final matchesModel =
              selectedModels.isEmpty || selectedModels.contains(p.carModel);
          final matchesYear =
              selectedYears.isEmpty || selectedYears.contains(p.carYear);
          final matchesPrice =
              p.price >= priceRange.start && p.price <= priceRange.end;
          return matchesName &&
              matchesBrand &&
              matchesModel &&
              matchesYear &&
              matchesPrice;
        }).toList();

    switch (selectedSort) {
      case 'Name A-Z':
        displayedProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name Z-A':
        displayedProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price Low-High':
        displayedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price High-Low':
        displayedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    setState(() {});
  }

  void navigateToProduct(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 104, 9, 9)),
          ClipPath(
            clipper: DiagonalClipper(),
            child: Container(color: const Color(0xFF1C1C1E)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 104, 9, 9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.categoryName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Sort by: ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          DropdownButton<String>(
                            value: selectedSort,
                            dropdownColor: Colors.black87,
                            style: const TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.white70,
                            items:
                                [
                                  'Name A-Z',
                                  'Name Z-A',
                                  'Price Low-High',
                                  'Price High-Low',
                                ].map((label) {
                                  return DropdownMenuItem(
                                    value: label,
                                    child: Text(label),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              selectedSort = value!;
                              applyFilters();
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: showFilterSheet,
                        child: const Text(
                          "Filter by",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      products == null
                          ? const Loader()
                          : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                            itemCount: displayedProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                            itemBuilder: (context, index) {
                              final product = displayedProducts[index];
                              return GestureDetector(
                                onTap: () => navigateToProduct(product),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          child: Image.network(
                                            product.images[0],
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.white70,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white70,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "\$${product.price.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
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
        ],
      ),
    );
  }

  void showFilterSheet() {
    final allNames = products!.map((e) => e.name).toSet().toList();
    final allBrands = products!.map((e) => e.carBrand).toSet().toList();
    final allModels = products!.map((e) => e.carModel).toSet().toList();
    final allYears = products!.map((e) => e.carYear).toSet().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // ✅ fully expanded on open
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  margin: const EdgeInsets.only(top: 50),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      buildExpansion(
                        "Product Name",
                        allNames,
                        selectedNames,
                        setModalState,
                      ),
                      buildExpansion(
                        "Car Brand",
                        allBrands,
                        selectedBrands,
                        setModalState,
                      ),
                      buildExpansion(
                        "Car Model",
                        allModels,
                        selectedModels,
                        setModalState,
                      ),
                      buildExpansion(
                        "Car Year",
                        allYears,
                        selectedYears,
                        setModalState,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Price Range",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 10000,
                        divisions: 100,
                        labels: RangeLabels(
                          '\$${priceRange.start.round()}',
                          '\$${priceRange.end.round()}',
                        ),
                        onChanged:
                            (values) =>
                                setModalState(() => priceRange = values),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          applyFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 104, 9, 9),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Apply",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            selectedNames.clear();
                            selectedBrands.clear();
                            selectedModels.clear();
                            selectedYears.clear();
                            priceRange = const RangeValues(0, 10000);
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pop(context);
                            applyFilters();
                          });
                        },
                        child: const Text(
                          "Reset Filters",
                          style: TextStyle(
                            color: Color.fromARGB(255, 104, 9, 9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildExpansion(
    String title,
    List<String> options,
    Set<String> selectedSet,
    StateSetter setModalState,
  ) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children:
          options
              .map(
                (item) => CheckboxListTile(
                  title: Text(item),
                  value: selectedSet.contains(item),
                  onChanged: (checked) {
                    setModalState(() {
                      if (checked!) {
                        selectedSet.add(item);
                      } else {
                        selectedSet.remove(item);
                      }
                    });
                  },
                ),
              )
              .toList(),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
