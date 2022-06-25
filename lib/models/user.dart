// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.image,
    required this.carts,
    required this.orders,
    required this.wishlists,
    required this.subtotal,
  });

  int id;
  String name;
  String username;
  String email;
  String phone;
  String image;
  int carts;
  int orders;
  int wishlists;
  int subtotal;
  String baseURL = "http://10.10.9.217/bumdes_api/public/storage";

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        carts: json["carts"],
        orders: json["orders"],
        wishlists: json["wishlists"],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "image": "$image",
        "carts": carts,
        "orders": orders,
        "wishlists": wishlists,
        "subtotal": subtotal,
      };
}
