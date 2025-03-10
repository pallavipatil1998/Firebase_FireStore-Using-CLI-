class NoteUserModel {
  String? name;
  String? id;
  String? email;
  int? age;
  String? gender;

  NoteUserModel({this.email, this.id, this.name, this.age, this.gender});

  factory NoteUserModel.fromJson(Map<String, dynamic> json) {
    return NoteUserModel(
       id: json["id"],
        name: json['name'],
        email: json['email'],
        age: json['age'],
        gender: json['gender']);

  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "age": age,
      "email": email,
      "name": name,
      "gender":gender,
    };
  }
}
