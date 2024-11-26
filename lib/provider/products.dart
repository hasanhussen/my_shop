import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  List<Product> items = [];
  late String authToken;
  late String userId;
  var isuserLoading = false;
  var isLoading = false;
  var showOnlyFavorites = false;

  void getData(String authTok, String uid) {
    authToken = authTok;
    userId = uid;
    notifyListeners();
    fetchAndSetProducts();
  }

  void onlyFavorites(FilterOption selectedVal) {
    if (selectedVal == FilterOption.Favorites) {
      showOnlyFavorites = true;
    } else {
      showOnlyFavorites = false;
    }
    notifyListeners();
  }

  List<Product> get favoritesItems {
    return items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product finfById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> saveuserForm() async {
    await fetchAndSetProducts(true);
  }

  Future<void> fetchAndSetProducts([bool fiterByUser = false]) async {
    final filteredString =
        fiterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'Your RealTime database url/products.json?auth=$authToken&$filteredString';
    try {
      if (fiterByUser == false) {
        isLoading = true;
        notifyListeners();
      }
      final res = await http.get(Uri.parse(url));
      final extractData = json.decode(res.body) as Map<String, dynamic>?;

      if (extractData == null) {
        return;
      }

      url =
          'Your RealTime database url/userFavories/$userId.json?auth=$authToken';
      final favRes = await http.get(Uri.parse(url));
      final favData = json.decode(favRes.body);

      final List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: (prodData['price'] is int)
                ? prodData['price'].toDouble()
                : double.parse(prodData['price'].toString()),
            imageUrl: prodData['imageUrl'],
            isFavorite: favData != null ? (favData[prodId] ?? false) : false));
      });
      items = loadedProducts;
      if (fiterByUser == false) {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'Your RealTime database url/products.json?auth=$authToken';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
          }));
      final newProduct = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          'Your RealTime database url/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('Product not found');
    }
  }

  Future<void> deleteProduct(String id) async {
    final productIndex = items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url =
          'Your RealTime database url/products/$id.json?auth=$authToken';
      Product? existingProduct = items[productIndex];
      items.removeAt(productIndex);
      notifyListeners();

      final res = await http.delete(Uri.parse(url));
      if (res.statusCode >= 400) {
        items.insert(productIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
      existingProduct = null;
    } else {
      print('Product not found');
    }
  }

  Future<void> toggleFavoriteStatus(
      String token, String userId, String id) async {
    final productIndex = items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final product = items[productIndex];
      final oldStatus = product.isFavorite;
      product.isFavorite = !product.isFavorite;
      notifyListeners();

      final url =
          'Your RealTime database url/userFavories/$userId/$id.json?auth=$token';

      try {
        final res = await http.put(Uri.parse(url),
            body: json.encode(product.isFavorite));
        if (res.statusCode >= 400) {
          product.isFavorite = oldStatus;
          notifyListeners();
        }
      } catch (e) {
        product.isFavorite = oldStatus;
        notifyListeners();
      }
    }
  }
}

enum FilterOption { Favorites, All }
