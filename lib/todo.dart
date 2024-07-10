import 'dart:convert' as JSON;

class Todo {
  final int index;
  final String title;
  final String? description;

  Todo(this.index, this.title, [this.description]);

  static Todo fromJSON(String str) {
    return JSON.jsonDecode(str);
  }

  String toJSON() {
    return JSON.jsonEncode(this);
  }
}