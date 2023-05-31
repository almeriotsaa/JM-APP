class User {
  final String? name;
  final String? email;
  final String? numberPhone;
  final int? id;

  User({
    this.name,
    this.email,
    this.numberPhone,
    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      numberPhone: json['number_phone'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['number_phone'] = numberPhone;
    data['id'] = id;
    return data;
  }
}