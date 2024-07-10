import 'package:localstorage/localstorage.dart';
import 'package:todo/todo.dart';

class SearchHandler {
  static Future<List<Todo>> getTodos(String searchText) async {
    print("Getting todos");
    List<Todo> todos = [];
    for (int index = 0; index < localStorage.length; index++) {
      String? todoJSON = localStorage.getItem("$index");
      if (todoJSON == null) continue;
      Todo todo = Todo.fromJSON(todoJSON);
      if (todo.title.toUpperCase().startsWith(searchText.toUpperCase())) {
        todos.add(todo);
      }
    }
    print("Got todos");
    return todos;
  }
}