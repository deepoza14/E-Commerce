import 'package:ecommerce/alert_dialog/cartisemptyalert.dart';
import 'package:ecommerce/authentication/login_screen.dart';
import 'package:ecommerce/bottomsheet/addressbottomsheet.dart';
import 'package:ecommerce/database/address_database.dart';
import 'package:ecommerce/database/cart_database.dart';
import 'package:ecommerce/database/wishlist_database.dart';
import 'package:ecommerce/screens/homepage.dart';
import 'package:ecommerce/screens/selectaddress.dart';
import 'package:ecommerce/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  CartState createState() => CartState();
}

class CartState extends State<Cart> {
  Future<List<Map<String, dynamic>>> _cartItemsFuture =
      CartDatabase.getCartItems();
  double subtotal = 0;
  String? logincheck;

  @override
  void initState() {
    super.initState();
    calculateSubtotal();
    fetchAddresses();
    checkLogin();
  }

  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logincheck = prefs.getString("login");
  }

  List<Map<String, dynamic>> addresses = [];

  void fetchAddresses() async {
    final List<Map<String, dynamic>> fetchedAddresses =
        await AddressDatabase.getAddresses();
    setState(() {
      addresses = fetchedAddresses;
    });
  }

  void calculateSubtotal() async {
    List<Map<String, dynamic>> cartItems = await _cartItemsFuture;

    double tempSubtotal = 0;
    for (var item in cartItems) {
      int quantity = item['quantity'] ?? 1;
      double price = item['price'] is String
          ? double.tryParse(item['price'].replaceAll(',', '')) ?? 0
          : (item['price'] ?? 0).toDouble();
      tempSubtotal += price * quantity;
    }

    setState(() {
      subtotal = tempSubtotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColorTheme.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Homepage()),
              );
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WishListScreen(),
                ),
              );*/
            },
            icon: const Icon(Icons.favorite),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const AddressesBottomSheetWidget(),
                  );
                },
                child: const Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.location_on,
                      size: 14,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Thane 400603",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _cartItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                List<Map<String, dynamic>> cartItems = snapshot.data ?? [];

                if (cartItems.isEmpty) {
                  return Center(
                    child: Image.asset("assets/images/empty.png"),
                  );
                }

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    int quantity = item['quantity'] ?? 1;

                    void updateCartItemQuantity(
                        String title, int quantity) async {
                      await CartDatabase.updateCartItemQuantity(
                          title, quantity);
                      setState(() {
                        _cartItemsFuture = CartDatabase.getCartItems();
                      });
                    }

                    void incrementQuantity() {
                      setState(() {
                        quantity++;
                        updateCartItemQuantity(item['title'], quantity);

                        // Recalculate the subtotal when quantity is incremented
                        double price = item['price'] is String
                            ? double.tryParse(
                                    item['price'].replaceAll(',', '')) ??
                                0
                            : (item['price'] ?? 0).toDouble();
                        subtotal += price;
                      });
                    }

                    void decrementQuantity() {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                          updateCartItemQuantity(item['title'], quantity);
                          // Recalculate the subtotal when quantity is decremented
                          double price = item['price'] is String
                              ? double.tryParse(
                                      item['price'].replaceAll(',', '')) ??
                                  0
                              : (item['price'] ?? 0).toDouble();
                          subtotal -= price;
                        }
                      });
                    }

                    void removeItemFromCart() {
                      double price = item['price'] is String
                          ? double.tryParse(
                                  item['price'].replaceAll(',', '')) ??
                              0
                          : (item['price'] ?? 0).toDouble();
                      int quantity = item['quantity'] ?? 1;

                      CartDatabase.removeFromCart(item['title']);
                      setState(() {
                        _cartItemsFuture = CartDatabase.getCartItems();
                        // Recalculate the subtotal when an item is removed
                        subtotal -= price * quantity;
                      });
                    }

                    final imageUrl = item['image'];

                    Widget imageWidget;

                    if (imageUrl != null && Uri.parse(imageUrl).isAbsolute) {
                      imageWidget = Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        height: 135,
                        width: 135,
                      );
                    } else {
                      imageWidget = Image.asset(
                        'assets/images/noimage.png',
                        fit: BoxFit.contain,
                        height: 135,
                        width: 135,
                      );
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            imageWidget,
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 235,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 235,
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Text(
                                      '₹${item['price']}',
                                      style: const TextStyle(
                                        fontSize: 20,
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
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
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
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12,
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => quantity == 1
                                            ? removeItemFromCart()
                                            : decrementQuantity(),
                                        child: Container(
                                          width: 30,
                                          height: 32,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            quantity == 1
                                                ? Icons.delete
                                                : Icons.remove,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black12,
                                              width: 1.5),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        child: Container(
                                          width: 30,
                                          height: 32,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$quantity',
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => incrementQuantity(),
                                        child: Container(
                                          width: 30,
                                          height: 32,
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.add,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    Card(
                                      color: MyColorTheme.whiteColor,
                                      elevation: 2,
                                      child: TextButton(
                                        onPressed: removeItemFromCart,
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      elevation: 2,
                                      color: MyColorTheme.whiteColor,
                                      child: TextButton(
                                        onPressed: () {
                                          WishlistDatabase.addToWishlist(
                                            title: item['title'],
                                            image: item['image'],
                                            price: item['price'],
                                          );
                                          // Optionally, you can show a snackbar or display a message to indicate that the item was added to the wishlist.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Added to wishlist'),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Add to Wishlist",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Total: ₹${subtotal.toStringAsFixed(2)}")),
                SizedBox(
                  width: 200,
                  height: 40.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColorTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (subtotal > 0) {
                        if (logincheck != "login") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectAddress(),
                            ),
                          );
                        }
                      } else {
                        showCartIsEmptyDialog(context);
                      }
                    },
                    child: const Text(
                      "CHECKOUT",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
