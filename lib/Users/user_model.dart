class UserModel {
  String? name;
  String? id;
  String? email;
  int? age;

  UserModel({this.email, this.id, this.name, this.age});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "email": email,
      "name": name,
    };
  }
}
