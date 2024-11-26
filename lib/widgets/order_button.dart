import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return TextButton(
      onPressed: () {
        cart.onOrderButton(context);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 176, 171, 171))),
      child: cart.isLoading
          ? const CircularProgressIndicator()
          : const Text(
              'ORDER NOW',
              style: TextStyle(color: Colors.white),
            ),
    ); // FlatButton
  }
}
