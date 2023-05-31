class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final String image;
  final int userId;
  final UserOwner user;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.userId,
    required this.user,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    description: json["description"],
    image: json["image"],
    userId: json["user_id"],
    user: UserOwner.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
    "image": image,
    "user_id": userId,
    "user": user.toJson(),
  };
}

class UserOwner {
  final int id;
  final String name;
  final String email;
  final String numberPhone;

  UserOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.numberPhone,
  });

  factory UserOwner.fromJson(Map<String, dynamic> json) =>
      UserOwner(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        numberPhone: json["number_phone"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "email": email,
        "number_phone": numberPhone,
      };
}
