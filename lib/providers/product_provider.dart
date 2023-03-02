import 'package:flutter/foundation.dart';
import 'package:nzuri_shop/database/database.dart';

import '../models/product_model.dart';
import '../services/api_call_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _newSearchedProducts = [];

  List<Product> _cartProducts = [];

  //Fetch list of products from APICallService class
  Future<List<Product>> getProductsFromApi() async {
    _products = await ApiCallService.fetchProducts();
    notifyListeners();
    return _products;
  }

  //Get sorted products by price from APICallService class
  Future<List<Product>> getSortedProductsByPrice() async {
    _products = await ApiCallService.fetchProducts();
    _products.sort(
        ((a, b) => double.parse(a.price).compareTo(double.parse(b.price))));
    notifyListeners();
    return _products;
  }

  //Get sorted products by rate from APICallService class
  Future<List<Product>> getSortedProductsByRate() async {
    _products = await ApiCallService.fetchProducts();
    _products.sort(((a, b) =>
        double.parse(a.rating.rate).compareTo(double.parse(b.rating.rate))));
    notifyListeners();
    return _products;
  }

  //Search product by title
  Future<List<Product>> searchProductByNameFromAPI(String keyword) async {
    _products = await ApiCallService.fetchProducts();
    _newSearchedProducts = _products
        .where((product) =>
            product.title.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    notifyListeners();
    return _newSearchedProducts;
  }

  searchProductByName(String keyword) async {
    _products = await searchProductByNameFromAPI(keyword);
    notifyListeners();
  }

  //Add getter for all products
  List<Product> get products => _products;

  //Add getter for searched products
  List<Product> get searchedProducts => _newSearchedProducts;

  //Get all cart items from Database
  Future<List<Product>> getAllCartItemsFromDatabase() async {
    _cartProducts = await MyCartDatabase.instance.getCartProducts();
    notifyListeners();
    return _cartProducts;
  }

  //Get all cart products
  List<Product> get cartProducts => _cartProducts;

  //Get total cart products amount
  double get totalCartAmount => cartProducts.fold(
      0, (total, product) => total + double.parse(product.price));

  //Addiing products to cart
  void addToCart(Product product) {
    // _cartProducts.add(product);
    addToDatabaseCart(product);

    notifyListeners();
  }

  addToDatabaseCart(product) async {
    await MyCartDatabase.instance.add(Product(
        id: product.id,
        title: product.title,
        image: product.image,
        price: product.price,
        description: product.description,
        category: product.category,
        rating: product.rating));
    notifyListeners();
  }

  //Remove products from cart
  void removeFromCart(Product product) {
    // _cartProducts.remove(product);
    removeFromDatabaseCart(product);

    notifyListeners();
  }

  removeFromDatabaseCart(product) async {
    await MyCartDatabase.instance.delete(Product(
        id: product.id,
        title: product.title,
        image: product.image,
        price: product.price,
        description: product.description,
        category: product.category,
        rating: product.rating));

    notifyListeners();
  }
}
