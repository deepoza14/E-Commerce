import 'package:ecommerce/bottomsheet/sortbottomsheet.dart';
import 'package:ecommerce/database/wishlist_database.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/screens/cart.dart';
import 'package:ecommerce/screens/productdetail.dart';
import 'package:ecommerce/screens/wishlist.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Product> getProducts = [];
  String baseUrl = "https://fakestoreapi.com/products";
  int selectedRowIndex = -1; // Add the selectedRowIndex variable here
  List<bool> isFavoriteList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true; // Add a loading indicator variable

  @override
  void initState() {
    super.initState();
    getProductsFromApi();
    initFavoriteStatus();
  }

  void initFavoriteStatus() async {
    List<Map<String, dynamic>> wishlistItems =
        await WishlistDatabase.getWishlistItems();
    setState(() {
      isFavoriteList = List<bool>.generate(
          getProducts.length,
          (index) => wishlistItems.any((item) =>
              item[WishlistDatabase.columnTitle] == getProducts[index].title));
    });
  }

  void performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search bar is empty, reset the product list to the original list
        getProductsFromApi();
      } else {
        // Filter the products based on the search query
        getProducts = getProducts.where((product) {
          final title = product.title.toLowerCase();
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery);
        }).toList();
      }
    });
  }

  void toggleFavorite(int index) async {
    if (isFavoriteList[index]) {
      // Product is in Wishlist, so remove it
      await WishlistDatabase.removeFromWishlist(getProducts[index].title);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from wishlist'),
        ),
      );
    } else {
      // Product is not in Wishlist, so add it
      await WishlistDatabase.addToWishlist(
        title: getProducts[index].title,
        image: getProducts[index].image,
        price: getProducts[index].price.toString(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to wishlist'),
        ),
      );
    }

    setState(() {
      // Toggle the favorite status for the product
      isFavoriteList[index] = !isFavoriteList[index];
    });
  }

  void onRowTapped(int index) {
    setState(() {
      selectedRowIndex = index;
    });

    getProductsFromApi(); // Call getProductsFromApi with the new selected sorting option
    Navigator.pop(
        context); // Close the bottom sheet after selecting a sorting option
  }

  Future<void> getProductsFromApi() async {
    try {
      String url = baseUrl;

      // Check if any sorting option is selected
      if (selectedRowIndex != -1) {
        switch (selectedRowIndex) {
          case 0:
            url = "$baseUrl?limit=5";
            break;
          case 1:
            url = "$baseUrl?sort=asc";
            break;
          case 2:
            url = "$baseUrl?sort=desc";
            break;
          case 3:
            url = "$baseUrl/category/electronics";
            break;
          case 4:
            url = "$baseUrl/category/jewelery";
            break;
          case 5:
            url = "$baseUrl/category/men's clothing";
            break;
          case 6:
            url = "$baseUrl/category/women's clothing";
            break;
          default:
            break;
        }
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
          getProducts = productFromJson(response.body);
          isFavoriteList = List<bool>.filled(getProducts.length, false);
          isLoading = false;
        });
        }
      } else {
        if (mounted) {
          setState(() {
          isLoading = false;
        });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
        isLoading = false;
      });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColorTheme.whiteColor,
      appBar: AppBar(
        backgroundColor: MyColorTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => SortBottomSheetWidget(
                selectedRowIndex: selectedRowIndex,
                // Pass the selectedRowIndex to SortBottomSheetWidget
                onRowTapped:
                    onRowTapped, // Pass the onRowTapped method to SortBottomSheetWidget
              ),
            );
          },
          icon: Icon(
            Icons.filter_alt_sharp,
            color: MyColorTheme.whiteColor,
          ),
        ),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color:
                    Colors.red), // Add this line to set the border color to red
          ),
          child: Center(
            child: TextField(
              controller: searchController,
              onChanged: performSearch,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: MyColorTheme.primaryColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: MyColorTheme.primaryColor,
                  ),
                  onPressed: () {
                    searchController.clear();
                    getProductsFromApi();
                    FocusScope.of(context).unfocus();
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishListScreen()),
              );
            },
            icon: const Icon(Icons.favorite),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Cart()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            color: Colors.white,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: getProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = getProducts[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(product: product),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  product.image,
                                  fit: BoxFit.contain,
                                  height: 135,
                                  width: 135,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 235,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      width: 235,
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: Text(
                                        "₹${product.price}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      width: 235,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: const Text(
                                          'Eligible for FREE Shipping'),
                                    ),
                                    Container(
                                      width: 235,
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 5),
                                      child: const Text(
                                        'In Stock',
                                        style: TextStyle(
                                          color: Colors.teal,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () => toggleFavorite(index),
                                    icon: Icon(
                                      isFavoriteList[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: MyColorTheme.primaryColor,
                                    ),
                                  ),
                                )
                              ],
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
