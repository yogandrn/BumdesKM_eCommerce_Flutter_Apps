import 'dart:convert';

class ProductInfo {
  //Now let's create the class constructor
  ProductInfo({
    required int id,
    required String name,
    required String description,
    required String imgURL,
    required int price,
    required int stock,
    required bool isFavorite,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _imgURL = imgURL;
    _price = price;
    _stock = stock;
    _isFavorite = isFavorite;
  }

  //Let's first create the getter methods
  //the id of the product as it's present in the firestore database
  int get id => _id;

  //the title of the product
  String get name => _name;

  //the description of the product
  String get description => _description;

  //This variables present the image's link on the product card
  String get imgURL => _imgURL;

  //the price of the product
  int get price => _price;

  //the stock of the product
  int get stock => _stock;

  //this field declare wether this item is liked by the current user or not
  bool get isFavorite => _isFavorite;

  ProductInfo.fromFirebase(Map<String, dynamic> data, int id, bool isFavorite) {
    _id = id;
    _name = data["name"];
    _description = data["description"];
    _imgURL = data["imgURL"];
    _price = data["price"];
    _stock = data["stock"];
    _isFavorite = isFavorite;
  }

  late String _categoryId;
  late String _imgURL;
  late String _description;
  late int _id;
  late int _likes;
  late int _price;
  late int _stock;
  late String _publisherId;
  late double _rate;
  late String _name;
  late String _brandId;
  late bool _isFavorite;

  //Now lets create a toMap function so we can convert the product to json format easily
  Map<String, dynamic> toMap() {
    //Here we need to import the intl package
    return {
      "name": name,
      "description": description,
      "imgURL": imgURL,
      "price": price,
      "stock": stock,
    };
  }

  @override
  String toString() {
    return '''
      ProductInfo(
        id: $id,
        name: $name,
        description: $description,
        images: $imgURL,
        price: $price,
        stock: $stock,
        isFavorite: $isFavorite,
      );
    ''';
  }
}

// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.message,
    required this.data,
  });

  String message;
  List<Datum> data;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.description,
    required this.materials,
    required this.price,
    required this.stock,
    required this.weight,
    required this.sold,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
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
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        materials: json["materials"],
        price: json["price"],
        stock: json["stock"],
        weight: json["weight"],
        sold: json["sold"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}



// class ProductInfo {
//   //Now let's create the class constructor
//   ProductInfo({
//     required String categoryId,
//     required String coverImageURL,
//     required DateTime createdAt,
//     required String currency,
//     required String description,
//     required String id,
//     required List<String> imagesURLs,
//     required int likes,
//     required double price,
//     required String publisherId,
//     required double rate,
//     required String title,
//     required String brandId,
//     required bool isFavorite,
//   }) {
//     _categoryId = categoryId;
//     _coverImageURL = coverImageURL;
//     _createdAt = createdAt;
//     _currency = currency;
//     _description = description;
//     _id = id;
//     _images = imagesURLs;
//     _likes = likes;
//     _price = price;
//     _publisherId = publisherId;
//     _rate = rate;
//     _title = title;
//     _brandId = brandId;
//     _isFavorite = isFavorite;
//   }

//   //Now we need to create a constructor for the firebase
//   ProductInfo.fromFirebase(
//       Map<String, dynamic> data, String id, bool isFavorite) {
//     _categoryId = data["category_id"];
//     _coverImageURL = data["cover_image"];
//     _createdAt = DateTime.parse(data["created_at"]);
//     _currency = data["currency"];
//     _description = data["description"];
//     _id = id;
//     _images = data["images"];
//     _likes = data["likes"];
//     _price = data["price"];
//     _publisherId = data["publisher_id"];
//     _rate = data["rate"];
//     _title = data["title"];
//     _brandId = data["brand_id"];
//     _isFavorite = isFavorite;
//   }

//   late String _categoryId;
//   late String _coverImageURL;
//   late DateTime _createdAt;
//   late String _currency;
//   late String _description;
//   late String _id;
//   late List<String> _images;
//   late int _likes;
//   late double _price;
//   late String _publisherId;
//   late double _rate;
//   late String _title;
//   late String _brandId;
//   late bool _isFavorite;

//   //Now lets create a toMap function so we can convert the product to json format easily
//   Map<String, dynamic> toMap() {
//     //Here we need to import the intl package
//     return {
//       "category_id": categoryId,
//       "cover_image": coverImage,
//       "created_at": DateFormat("yyyy-MM-dd hh:mm:ss", "en").format(createdAt),
//       "currency": currency,
//       "description": description,
//       "likes": likesCount,
//       "price": price,
//       "publisher_id": publisherId,
//       "rate": rate,
//       "title": title,
//       "brand_id": brandId,
//     };
//   }

//   //Let's first create the getter methods
//   //in this variable we are storing the category id, to reference on the category on which this product came from
//   String get categoryId => _categoryId;

//   //This variables present the image's link on the product card
//   String get coverImage => _coverImageURL;

//   //the date on which this product is created
//   DateTime get createdAt => _createdAt;

//   //the currency of the price
//   String get currency => _currency;

//   //the description of the product
//   String get description => _description;

//   //the id of the product as it's present in the firestore database
//   String get id => _id;

//   //this list is holding the images of the product to be displayed in the details screen
//   List<String> get images => _images;

//   //the number of persons that liked this product
//   int get likesCount => _likes;

//   //the price of the product
//   double get price => _price;

//   //the seller id
//   String get publisherId => _publisherId;

//   //the rate of the product
//   double get rate => _rate;

//   //the title of the product
//   String get title => _title;

//   //this field is added to represent the product's subcategory or brand
//   String get brandId => _brandId;

//   //this field declare wether this item is liked by the current user or not
//   bool get isFavorite => _isFavorite;

//   @override
//   String toString() {
//     String images = "[\n";
//     for (String image in this.images) {
//       image += "\t" + image + ",\n";
//     }
//     images += "]";
//     return '''
//       ProductInfo(
//         categoryId: $categoryId,
//         coverImage: $coverImage,
//         currency: $currency,
//         description: $description,
//         id: $id,
//         images: $images,
//         likesCount: $likesCount,
//         price: $price,
//         publisherId: $publisherId,
//         rate: $rate,
//         title: $title,
//         brandId: $brandId,
//         isFavorite: $isFavorite,
//       );
//     ''';
//   }
// }