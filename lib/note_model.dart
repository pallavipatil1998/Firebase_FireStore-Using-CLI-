class NoteModel {
  String? body;
  int? id;
  String? title;

  NoteModel({this.body, this.title, this.id});


  factory NoteModel.fromJson(Map<String, dynamic> json){
    return NoteModel(
      body: json['body'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "body" : body,
      "title": title,
    };
  }
}