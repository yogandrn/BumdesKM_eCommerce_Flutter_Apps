// To parse this JSON data, do
//
//     final detailProduct = detailProductFromJson(jsonString);

import 'dart:convert';

List<DetailProduct> detailProductFromJson(String str) =>
    List<DetailProduct>.from(
        json.decode(str).map((x) => DetailProduct.fromJson(x)));

String detailProductToJson(List<DetailProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailProduct {
  DetailProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.materials,
    required this.price,
    required this.stock,
    required this.weight,
    required this.sold,
    required this.image,
  });

  int id;
  String title;
  String description;
  String materials;
  int price;
  int stock;
  int weight;
  int sold;
  String image;

  factory DetailProduct.fromJson(Map<String, dynamic> json) => DetailProduct(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        materials: json["materials"],
        price: json["price"],
        stock: json["stock"],
        weight: json["weight"],
        sold: json["sold"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "materials": materials,
        "price": price,
        "stock": stock,
        "weight": weight,
        "sold": sold,
        "image": image,
      };

  @override
  String toString() {
    return '''
      ProductInfo(
        id: $id,
        name: $title,
        description: $description,
        materials: $materials,
        price: $price,
        stock: $stock,
        weight: $weight,
        sold: $sold,
        images: $image,
      );
    ''';
  }
}
