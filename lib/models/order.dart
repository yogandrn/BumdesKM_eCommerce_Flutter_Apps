import 'dart:convert';
// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

// List<Order> orderFromJson(String str) =>
//     List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

// String orderToJson(List<Order> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    required this.id,
    required this.idUser,
    required this.date,
    required this.total,
    required this.status,
    required this.image,
  });

  int id;
  int idUser;
  String date;
  int total;
  String status;
  String image;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        idUser: json["id_user"],
        date: json["date"],
        total: json["total"],
        status: json["status"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "date": date,
        "total": total,
        "status": status,
        "image": image,
      };
}

// To parse this JSON data, do
//
//     final orderItem = orderItemFromJson(jsonString);

// List<OrderItem> orderItemFromJson(String str) => List<OrderItem>.from(json.decode(str).map((x) => OrderItem.fromJson(x)));

// String orderItemToJson(List<OrderItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderItem {
  OrderItem({
    required this.id,
    required this.idProduct,
    required this.title,
    required this.price,
    required this.qty,
    required this.subtotal,
    required this.image,
  });

  int id;
  int idProduct;
  String title;
  int price;
  int qty;
  int subtotal;
  String image;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        idProduct: json["id_product"],
        title: json["title"],
        price: json["price"],
        qty: json["qty"],
        subtotal: json["subtotal"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_product": idProduct,
        "title": title,
        "price": price,
        "qty": qty,
        "subtotal": subtotal,
        "image": image,
      };
}
