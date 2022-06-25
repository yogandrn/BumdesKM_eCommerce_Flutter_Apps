// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  Review({
    required this.id,
    required this.idTransaction,
    required this.idUser,
    required this.username,
    required this.image,
    required this.date,
    required this.time,
    required this.comment,
  });

  int id;
  int idTransaction;
  int idUser;
  String username;
  String image;
  DateTime date;
  String time;
  String comment;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        idTransaction: json["id_transaction"],
        idUser: json["id_user"],
        username: json["username"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_transaction": idTransaction,
        "id_user": idUser,
        "username": username,
        "image": image,
        "date": date.toIso8601String(),
        "time": time,
        "comment": comment,
      };
}
