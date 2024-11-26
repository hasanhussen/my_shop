import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItemW extends StatelessWidget {
  final Product product;
  const ProductItemW({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return Consumer<Products>(
      builder: (context, products, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  products.toggleFavoriteStatus(
                      authData.token!, authData.userId!, product.id.toString());
                },
              ),
              title: Text(product.title, textAlign: TextAlign.center),
              trailing: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Added to cart'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO!',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ));
                },
              ),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id),
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
