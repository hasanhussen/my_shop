import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/editproduct.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen..dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider<EditProducts>(create: (_) => EditProducts()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousOrders) {
            // ignore: unnecessary_null_comparison
            if (authValue != null) {
              previousOrders ??= Orders();
              previousOrders.getData(
                  authValue.token ?? '', authValue.userId ?? '');
              return previousOrders;
            } else {
              return previousOrders ?? Orders();
            }
          },
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProduct) {
            // ignore: unnecessary_null_comparison
            if (authValue != null) {
              previousProduct ??= Products();
              previousProduct.getData(
                  authValue.token ?? '', authValue.userId ?? '');
              return previousProduct;
            } else {
              return previousProduct ?? Products();
            }
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            hintColor: Colors.deepOrange,
            fontFamily: 'Lato',
            useMaterial3: true,
          ),
          home: auth.isAuth
              ? const ProductOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) {
                    if (authSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SplashScreen();
                    } else {
                      if (authSnapshot.data == true) {
                        return const ProductOverview();
                      } else {
                        return const AuthScreen();
                      }
                    }
                  },
                ),
          routes: {
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            ProductOverview.routeName: (context) => const ProductOverview(),
            UserProductScreen.routeName: (context) {
              context.read<Products>().fetchAndSetProducts(true);
              return const UserProductScreen();
            },
            CartScreen.routeName: (context) => const CartScreen(),
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
