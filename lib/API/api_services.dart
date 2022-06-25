import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bumdeskm/models/cart.dart';
import 'package:bumdeskm/models/detail_product.dart';
import 'package:bumdeskm/models/order.dart';
import 'package:bumdeskm/models/picsum.dart';
import 'package:bumdeskm/models/product.dart';
import 'package:bumdeskm/models/review.dart';
import 'package:bumdeskm/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseURL = 'https://ws-tif.com/kel16/api';
  var token;
  final String imgURL = "https://ws-tif.com/kel16/laravel/storage/app/public/";

  Future<List<Picsum>> get() async {
    try {
      final response =
          await http.get(Uri.parse("https://picsum.photos/v2/list"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Picsum>.from(json.map((e) => Picsum.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //PRODUK
  // ambil data semua produk
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse("$baseURL/products"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Product>.from(json.map((e) => Product.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> getBestSeller() async {
    try {
      final response =
          await http.get(Uri.parse("$baseURL/products/bestseller"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Product>.from(json.map((e) => Product.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> getAllBestSeller() async {
    try {
      final response =
          await http.get(Uri.parse("$baseURL/products/bestseller/all"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Product>.from(json.map((e) => Product.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // detail produk
  getDataProduct(var id) async {
    var fullURL = baseURL + "/product/show/$id";
    return await http.get(
      Uri.parse(fullURL),
    );
  }

  getImages(var id) async {
    return await http.get(Uri.parse("$baseURL/product/images/$id"),
        headers: _setHeaders());
  }

  Future<List<ProductImage>> getProductImage(var id) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/product/images/$id"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<ProductImage>.from(
            json.map((e) => ProductImage.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ambil data semua produk
  Future<List<Product>> searchProduct(var keyword) async {
    try {
      final response =
          await http.get(Uri.parse("$baseURL/products/search/$keyword"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Product>.from(json.map((e) => Product.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // _getProductImage(var id) async {
  //   return await http.get("$baseURL/product/images/$id",
  //       headers: _setHeaders());
  // }

  // KERANJANG
  // ambil data keranjang user
  Future<List<Cart>> getUserCarts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id_user');
    try {
      final response = await http.get(Uri.parse("$baseURL/carts/user/$id"),
          headers: _setHeaders());
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Cart>.from(json.map((e) => Cart.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ambil data keranjang
  _getUserCart(id) async {
    var fullURL = baseURL + "/carts/$id";
    return await http.get(Uri.parse(fullURL), headers: _setHeaders());
  }

  // masukkan keranjang
  addToCart(data) async {
    var fullURL = baseURL + "/add/cart";
    return await http.post(Uri.parse(fullURL),
        body: jsonEncode(data), headers: _setHeaders());
  }

  // hapus keranjang
  deleteCart(id) async {
    return await http.delete(Uri.parse(baseURL + "/carts/$id"),
        headers: _setHeaders());
  }

  // PESANAN
  // ambil data pesanan user
  Future<List<Order>> getUserOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id_user');
    try {
      final response = await http.get(Uri.parse("$baseURL/orders/user/$id"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Order>.from(json.map((e) => Order.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ambil data item order
  Future<List<OrderItem>> getOrderItem(id) async {
    try {
      final response = await http.get(Uri.parse("$baseURL/order/$id/detail"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<OrderItem>.from(json.map((e) => OrderItem.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ambil data transaksi
  getDataOrder(var id) async {
    return await http.get(Uri.parse("$baseURL/order/$id"),
        headers: _setHeaders());
  }

  // cek ongkir
  cekOngkir(data) async {
    return await http.post(
      Uri.parse("$baseURL/order/ongkir"),
      body: data,
    );
  }

  createOrder(data) async {
    return await http.post(Uri.parse("$baseURL/order"), body: data);
  }

  confirmOrder(data) async {
    return await http.post(
      Uri.parse("$baseURL/order/confirm/$data"),
      // body: json.encode(data),
    );
  }

  // REVIEW
  // get all reviews
  Future<List<Review>> getAllReviews() async {
    try {
      final response = await http.get(Uri.parse("$baseURL/reviews"));
      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return List<Review>.from(json.map((e) => Review.fromJson(e)));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  createReview(data) async {
    return await http.post(Uri.parse("$baseURL/review/create"),
        body: jsonEncode(data), headers: _setHeaders());
  }

  // auth login, register, logout
  auth(data, apiURL) async {
    var fullUrl = baseURL + apiURL;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id_user');
    var request =
        await http.get(Uri.parse("$baseURL/user/$id"), headers: _setHeaders());
    var body = jsonDecode(request.body);
    var subtotal = body['subtotal'];
    prefs.setInt('subtotal', subtotal);
    prefs.setInt('weight', body['weight']);
    return request;
  }

  Future _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var body = localStorage.getString('token');
    // token = jsonDecode(body)['token'];
  }

  cekPassword(var data) async {
    return await http.post(
      Uri.parse("$baseURL/user/check/password"),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  changePassword(var data) async {
    return await http.post(Uri.parse("$baseURL/user/change/password"),
        body: jsonEncode(data), headers: _setHeaders());
  }

  updateProfile(var data) async {
    return await http.post(Uri.parse("$baseURL/user/edit"),
        body: jsonEncode(data), headers: _setHeaders());
  }

  // ambil data user
  // Future<List<User>> _getUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var id = prefs.getInt('id_user');
  //   try {
  //     final response = await http.get(Uri.parse("$baseURL/user/$id"),
  //         headers: _setHeaders());
  //     if (response.statusCode == 200) {
  //       List<dynamic> json = jsonDecode(response.body);
  //       return List<User>.from(json.map((e) => User.fromJson(e)));
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     return [];
  //   }
  // }

  logout(apiURL) async {
    var fullUrl = baseURL + apiURL;
    await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      };

  // Future<List<String>> loadUserData() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var user = jsonDecode(localStorage.getString('user'));

  //   if (user != null) {
  //   return user;
  //     setState(() {
  //       name = user['name'];
  //     });
  //   }
  // }
}
