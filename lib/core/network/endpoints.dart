import 'package:order_track/core/utils/base_url_manager.dart';

class Endpoints {
  Endpoints._();

  //! not static since I don't have a paid domain
  static String _baseUrl = "https://default-base-url.com";
  static Future<void> initialize() async {
    final savedUrl = await BaseUrlManager.getBaseUrl();
    if (savedUrl != null) {
      _baseUrl = savedUrl;
    }
  }

  static String get baseUrl => _baseUrl;

  //* ORDERS
  static String getOrders() => "/orders";
  static String getOrderById({required int id}) => "/orders/$id";
  static String getOrdersByDistributorId({required String id}) =>
      "/orders?distributorId_eq=$id";
  static String getOrdersByClientId({required String id}) =>
      "/orders?clientId_eq=$id";
  static String postOrder() => "/orders";
  static String updateOrderById({required int id}) => "/orders/$id";
  static String deleteOrderById({required int id}) => "/orders/$id";

  //* DISTRIBUTORS
  static String getDistributors() => "/distributors";

  //* PRODUCTS
  static String getProducts() => "/products";
  static String getProductById({required String id}) => "/products/$id";
  static String updateProductById({required String id}) => "/products/$id";
}
