import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import '../models/product.dart';

class EditProducts with ChangeNotifier {
  final priceFocusNode = FocusNode();

  final descriptionFocusNode = FocusNode();

  final imageUrlController = TextEditingController();

  final imageUrlFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  var editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var initialValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  var isLoading = false;

  void updateimageUrl() {
    if (((!imageUrlController.text.startsWith('http') &&
            !imageUrlController.text.startsWith('https')) ||
        (!imageUrlController.text.endsWith('.png') &&
            !imageUrlController.text.endsWith('.jpg') &&
            !imageUrlController.text.endsWith('.jpeg')))) {
      return;
    }
    notifyListeners();
  }

  init(BuildContext context, [String? productId]) {
    // imageUrlFocusNode.addListener(_updateimageUrl);

    //final productId = ModalRoute.of(context)?.settings.arguments as String?;
    if (productId != null) {
      editedProduct =
          Provider.of<Products>(context, listen: false).finfById(productId);
      initialValues = {
        'title': editedProduct.title,
        'description': editedProduct.description,
        'price': editedProduct.price.toString(),
        'imageUrl': editedProduct.imageUrl,
      };
      imageUrlController.text = editedProduct.imageUrl;
    } else {
      editedProduct = Product(
        id: '',
        title: '',
        description: '',
        price: 0,
        imageUrl: '',
      );

      initialValues = {
        'title': '',
        'price': '',
        'description': '',
        'imageUrl': '',
      };
      imageUrlController.clear();
    }
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    imageUrlFocusNode.dispose();
    imageUrlController.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveForm(BuildContext context) async {
    final isValid = formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    formKey.currentState?.save();
    isLoading = true;
    notifyListeners();
    if (editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (e) {
        // ignore: use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                child: const Text('Okay!'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
        print('$e');
      }
      isLoading = false;
      notifyListeners();
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
