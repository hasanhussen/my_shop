import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    'Options',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              toolbarHeight: 40,
              automaticallyImplyLeading: false,
            ),
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.shop,
                size: 25,
              ),
              title: const Text(
                'Shop',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.payment,
                size: 25,
              ),
              title: const Text(
                'Orders',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.edit,
                size: 25,
              ),
              title: const Text(
                'Manage Products',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName);
              },
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 25,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
