import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/cart_screen..dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/products_grid.dart';

class ProductOverview extends StatelessWidget {
  static const routeName = '/ProductOverview';
  const ProductOverview({super.key});

  // var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedVal) {
              products.onlyFavorites(selectedVal);
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.Favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOption.All,
                child: Text('Show All'),
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
            builder: (_, cart, ch) => MyBadge(
                value: cart.itemCount.toString(),
                color: Theme.of(context).hintColor,
                child: ch!),
          )
        ],
      ),
      body: products.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(
              showFavs: products.showOnlyFavorites,
            ),
      drawer: const MyDrawer(),
    );
  }
}
