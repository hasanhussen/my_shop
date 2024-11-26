import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/editproduct.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';
  const UserProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Products"),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Provider.of<EditProducts>(context, listen: false)
                      .init(context);
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                }), // IconButton
          ],
        ), // AppBar
        drawer: const MyDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Products>(context, listen: false).saveuserForm(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Center(
                        child:
                            CircularProgressIndicator())); // عرض مؤشِّر تحميل
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}')); // عرض الخطأ
              } else {
                return Consumer<Products>(
                  builder: (ctx, productsData, _) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: productsData.items.length,
                      itemBuilder: (_, int index) => Column(
                        children: [
                          UserProductItem(
                            productsData.items[index].id,
                            productsData.items[index].title,
                            productsData.items[index].imageUrl,
                          ),
                          const Divider()
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
