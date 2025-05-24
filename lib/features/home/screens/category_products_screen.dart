import 'package:flutter/material.dart';
import 'package:nukdi4/features/home/services/home_services.dart';
import 'package:nukdi4/models/product.dart';
import 'package:nukdi4/common/widgets/loader.dart';
import 'package:nukdi4/features/product_details/screens/product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryId; // ✅ NEW: ID for filtering
  final String categoryName; // ✅ NEW: name for displaying

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
      categoryId: widget.categoryId, // ✅ use ID for backend filtering
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

    if (selectedSort == 'Name A-Z') {
      displayedProducts.sort((a, b) => a.name.compareTo(b.name));
    } else if (selectedSort == 'Name Z-A') {
      displayedProducts.sort((a, b) => b.name.compareTo(a.name));
    } else if (selectedSort == 'Price Low-High') {
      displayedProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort == 'Price High-Low') {
      displayedProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    setState(() {});
  }

  void showFilterSheet() {
    final allNames = products!.map((e) => e.name).toSet().toList();
    final allBrands = products!.map((e) => e.carBrand).toSet().toList();
    final allModels = products!.map((e) => e.carModel).toSet().toList();
    final allYears = products!.map((e) => e.carYear).toSet().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              builder:
                  (_, scrollController) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
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
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            applyFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                            Future.delayed(
                              const Duration(milliseconds: 100),
                              () {
                                Navigator.pop(context);
                                applyFilters();
                              },
                            );
                          },
                          child: const Text(
                            "Reset Filters",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children:
          options.map((item) {
            return CheckboxListTile(
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
            );
          }).toList(),
    );
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
      appBar: AppBar(
        title: Text(widget.categoryName.toUpperCase()), // ✅ show name on top
        backgroundColor: Colors.blue,
      ),
      body:
          products == null
              ? const Loader()
              : Column(
                children: [
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
                            const Text("Sort by: "),
                            DropdownButton<String>(
                              value: selectedSort,
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: displayedProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final product = displayedProducts[index];
                        return GestureDetector(
                          onTap: () => navigateToProduct(product),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1.4,
                                    child: Image.network(
                                      product.images[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
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
    );
  }
}
