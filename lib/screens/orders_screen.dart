import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var order = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Order"),
        ),
        drawer: const MyDrawer(),
        body: order.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (BuildContext context, int index) => MyOrderItem(
                    orderData.orders[index],
                  ),
                ),
              ));
  }
}
