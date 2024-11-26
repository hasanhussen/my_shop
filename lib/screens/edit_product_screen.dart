import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/provider/editproduct.dart';

class EditProductScreen extends StatelessWidget {
  static const routeName = '/ProductScreen';

  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Provider.of<EditProducts>(context, listen: false)
                  .saveForm(context);
            },
          ) // IconButton
        ],
      ), // AppBar
      body: Provider.of<EditProducts>(context).isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: Provider.of<EditProducts>(context, listen: false).formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue:
                          Provider.of<EditProducts>(context, listen: false)
                              .initialValues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            Provider.of<EditProducts>(context, listen: false)
                                .priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        Provider.of<EditProducts>(context, listen: false)
                            .editedProduct = Product(
                          id: Provider.of<EditProducts>(context, listen: false)
                              .editedProduct
                              .id,
                          price:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .price,
                          title: value!,
                          description:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .description,
                          imageUrl:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .imageUrl,
                          isFavorite:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue:
                          Provider.of<EditProducts>(context, listen: false)
                              .initialValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            Provider.of<EditProducts>(context, listen: false)
                                .descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        Provider.of<EditProducts>(context, listen: false)
                            .editedProduct = Product(
                          id: Provider.of<EditProducts>(context, listen: false)
                              .editedProduct
                              .id,
                          price: double.parse(value!),
                          title:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .title,
                          description:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .description,
                          imageUrl:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .imageUrl,
                          isFavorite:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue:
                          Provider.of<EditProducts>(context, listen: false)
                              .initialValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode:
                          Provider.of<EditProducts>(context, listen: false)
                              .descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        Provider.of<EditProducts>(context, listen: false)
                            .editedProduct = Product(
                          id: Provider.of<EditProducts>(context, listen: false)
                              .editedProduct
                              .id,
                          price:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .price,
                          title:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .title,
                          description: value!,
                          imageUrl:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .imageUrl,
                          isFavorite:
                              Provider.of<EditProducts>(context, listen: false)
                                  .editedProduct
                                  .isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child:
                              Provider.of<EditProducts>(context, listen: false)
                                      .imageUrlController
                                      .text
                                      .isEmpty
                                  ? const Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        Provider.of<EditProducts>(context,
                                                listen: false)
                                            .imageUrlController
                                            .text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        ),
                        Expanded(
                            child: TextFormField(
                                controller: Provider.of<EditProducts>(context,
                                        listen: false)
                                    .imageUrlController,
                                decoration: const InputDecoration(
                                    labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                focusNode: Provider.of<EditProducts>(context,
                                        listen: false)
                                    .imageUrlFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a image URL.';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  }
                                  if (!value.endsWith('png') &&
                                      !value.endsWith('jpg') &&
                                      !value.endsWith('jpeg')) {
                                    return 'Please enter a valid URL.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  print('Image URL: $value');
                                  Provider.of<EditProducts>(context,
                                          listen: false)
                                      .editedProduct = Product(
                                    id: Provider.of<EditProducts>(context,
                                            listen: false)
                                        .editedProduct
                                        .id,
                                    price: Provider.of<EditProducts>(context,
                                            listen: false)
                                        .editedProduct
                                        .price,
                                    title: Provider.of<EditProducts>(context,
                                            listen: false)
                                        .editedProduct
                                        .title,
                                    description: Provider.of<EditProducts>(
                                            context,
                                            listen: false)
                                        .editedProduct
                                        .description,
                                    imageUrl: Provider.of<EditProducts>(context,
                                            listen: false)
                                        .imageUrlController
                                        .text,
                                    isFavorite: Provider.of<EditProducts>(
                                            context,
                                            listen: false)
                                        .editedProduct
                                        .isFavorite,
                                  );
                                  print('Image URL: $value');
                                })),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (Provider.of<EditProducts>(context, listen: false)
                            .editedProduct
                            .id ==
                        '')
                      ElevatedButton(
                          onPressed: () {
                            Provider.of<EditProducts>(context, listen: false)
                                .updateimageUrl();
                          },
                          child: const Text('Show image'))
                  ],
                ),
              ),
            ),
    );
  }
}
