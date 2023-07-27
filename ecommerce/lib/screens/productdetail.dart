import 'package:ecommerce/database/cart_database.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/screens/cart.dart';
import 'package:ecommerce/screens/homepage.dart';
import 'package:ecommerce/screens/wishlist.dart';

import 'package:ecommerce/theme/color_theme.dart';
import 'package:ecommerce/theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:share_plus/share_plus.dart';

import '../database/wishlist_database.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  int itemCount = 1;

  bool isFavorite = false; // Track the favorite status

  void incrementItem() {
    setState(() {
      itemCount++;
    });
  }

  void decrementItem() {
    setState(() {
      if (itemCount > 0) {
        itemCount--;
      }
    });
  }

  void addToCart() {
    CartDatabase.addToCart(
      title: widget.product.title,
      image: widget.product.image,
      price: widget.product.price.toString(),
      quantity: itemCount,
    );
    // Optionally, you can show a snackbar or display a message to indicate that the item was added to the cart.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        WishlistDatabase.addToWishlist(
          title: widget.product.title,
          image: widget.product.image,
          price: widget.product.price.toString(),
        );
        // Optionally, you can show a snackbar or display a message to indicate that the item was added to the wishlist.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to wishlist'),
          ),
        );
      } else {
        WishlistDatabase.removeFromWishlist(widget.product.title);
        // Optionally, you can show a snackbar or display a message to indicate that the item was removed from the wishlist.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from wishlist'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColorTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: MyColorTheme.whiteColor),
        ),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Text(
                      'Search...',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WishListScreen()),
                );
              },
              icon: const Icon(Icons.favorite),
              color: MyColorTheme.whiteColor),
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Cart()),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  color: MyColorTheme.whiteColor),
              itemCount > 0
                  ? Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 260,
                    child: Image.network(widget.product.image),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: toggleFavorite,
                          // Call toggleFavorite when the favorite icon is clicked
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: MyColorTheme.primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: MyColorTheme.primaryColor,
                          ),
                          onPressed: () {
                            Share.share(
                                'check out my website https://example.com',
                                subject: 'Look what I made!');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  widget.product.title,
                  style: editTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "₹${widget.product.price}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  "(Incl. of all taxes)",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    RatingStars(
                      value: widget.product.rating.rate,
                      starSize: 16,
                      valueLabelColor: Colors.amber,
                      starColor: Colors.amber,
                    )
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "In Stock",
                  style: TextStyle(
                      color: MyColorTheme.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  alignment: const Alignment(-1.0, -1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.product.description,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 50.0,
        width: 200.0, // Set the width as needed
        decoration: BoxDecoration(
          color: MyColorTheme.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
              onPressed: decrementItem,
            ),
            Text(
              itemCount.toString(),
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: incrementItem,
            ),
            IconButton(
              icon: const Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
              ),
              onPressed: addToCart,
            ),
          ],
        ),
      ),
    );
  }
}
