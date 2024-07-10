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
        shape: const CircleBorder(),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator
              .of(context)
              .push(MaterialPageRoute(builder: (context) {
                return const AddTodoScreen();
          }));
        },
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

          return ListView.separated(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return TodoItemDisplay(todoList[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider();
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
    elevation: 1,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black,
    title: const Text("Todo"),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
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
    elevation: 1,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onSearchClose,
    ),
    title: TextField(
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withAlpha(200)),

      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.black.withAlpha(150)),
        border: InputBorder.none,
      ),
      onChanged: onSearchChange,
    ),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  );
}

class TodoItemDisplay extends StatelessWidget {
  final Todo todo;
  const TodoItemDisplay(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            todo.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (todo.description != null)
            Text(todo.description ?? "")
        ],
      ),
    );
  }
}
