// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

// List<Cart> cartFromJson(String str) =>
//     List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

// String cartToJson(List<Cart> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  Cart({
    required this.id,
    required this.idUser,
    required this.idProduct,
    required this.title,
    required this.image,
    required this.price,
    required this.qty,
    required this.subtotal,
  });

  int id;
  int idUser;
  int idProduct;
  String title;
  String image;
  int price;
  int qty;
  int subtotal;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        idUser: json["id_user"],
        idProduct: json["id_product"],
        title: json["title"],
        image: json["image"],
        price: json["price"],
        qty: json["qty"],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "id_product": idProduct,
        "title": title,
        "image": image,
        "price": price,
        "qty": qty,
        "subtotal": subtotal,
      };
}

// class Product {
//   Product(
//       {required this.id,
//       required this.title,
//       required this.description,
//       required this.materials,
//       required this.price,
//       required this.stock,
//       required this.weight,
//       required this.sold,
//       required this.image});

//   int id;
//   int price;
//   int stock;
//   int weight;
//   int sold;
//   String title;
//   String description;
//   String materials;
//   String image;

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//       id: json["id"],
//       title: json["title"],
//       description: json["description"],
//       materials: json["materials"],
//       price: json["price"],
//       stock: json["stock"],
//       weight: json["weight"],
//       sold: json["sold"],
//       image: json["image"]);

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "description": description,
//         "materials": materials,
//         "price": price,
//         "stock": stock,
//         "weight": weight,
//         "sold": sold,
//         "image": image
//       };
// }
