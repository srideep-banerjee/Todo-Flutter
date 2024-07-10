import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo/add_todo_screen.dart';
import 'package:todo/search_util.dart';
import 'package:todo/todo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool searchBarOpen = false;
  String searchText = "";
  late Future<List<Todo>> todosFuture;

  @override
  void initState() {
    todosFuture = SearchHandler.getTodos(searchText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = switch(searchBarOpen) {
      true => searchAppBar(
        context,
        onSearchChange: (str) {
          print("On Search Change: $str");
          setState(() {
            searchText = str;
            todosFuture.ignore();
            todosFuture = SearchHandler.getTodos(searchText);
          });
        },
        onSearchClose: () {
          setState(() {
            searchBarOpen = false;
            searchText = "";
          });
        },
      ),
      false => defaultAppBar(
        context,
        onSearchOpen: () {
          setState(() {
            searchBarOpen = true;
          });
        },
      )
    };
    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator
              .of(context)
              .push(MaterialPageRoute(builder: (context) {
                return const AddTodoScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Todo>>(
        future: todosFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: Text("Loading ..."),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("An Error occurred"),
            );
          }

          List<Todo> todoList = [];
          if (snapshot.hasData) todoList = snapshot.data!;

          if (todoList.isEmpty) {
            return const Center(
                child: Text("No todos found")
            );
          }

          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return TodoItemDisplay(todoList[index]);
            },
          );
        }
      ),
    );
  }
}

AppBar defaultAppBar(
    BuildContext context,
    {void Function()? onSearchOpen}
    ) {
  return AppBar(
    title: const Text("Todo"),
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: onSearchOpen,
      )
    ],
  );
}

AppBar searchAppBar(
    BuildContext context,
    {
      void Function(String str)? onSearchChange,
      void Function()? onSearchClose
    }
    ) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onSearchClose,
    ),
    title: TextField(
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      style: const TextStyle(color: Colors.white),

      decoration: const InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.white38),
        border: InputBorder.none,
      ),
      onChanged: onSearchChange,
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  );
}

class TodoItemDisplay extends StatelessWidget {
  final Todo todo;
  const TodoItemDisplay(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(todo.title),
        if (todo.description != null) 
          Text(todo.description ?? "")
      ],
    );
  }
}
