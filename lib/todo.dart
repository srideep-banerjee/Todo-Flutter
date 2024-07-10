import 'dart:convert' as JSON;

class Todo {
  final int index;
  final String title;
  final String? description;

  Todo(this.index, this.title, [this.description]);

  static Todo fromJSON(String str) {
    Map<String,dynamic> map = JSON.jsonDecode(str);
    return Todo(map["index"], map["title"], map["description"]);
  }

  String toJSON() {
    Map<String,dynamic> map = {
      "title": title,
      "description": description,
      "index": index,
    };
    return JSON.jsonEncode(map);
  }
}