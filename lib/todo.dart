import 'dart:convert' as JSON;

class Todo {
  final String title;
  final String? description;

  Todo(this.title, [this.description]);

  Todo fromJSON(String str) {
    return JSON.jsonDecode(str);
  }

  String toJSON() {
    return JSON.jsonEncode(this);
  }
}