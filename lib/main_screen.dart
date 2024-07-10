import 'package:flutter/material.dart';
import 'package:todo/add_todo_screen.dart';
import 'package:todo/todo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool searchBarOpen = false;
  TextEditingController controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    AppBar appBar = switch(searchBarOpen) {
      true => searchAppBar(
        context,
        controller,
        onSearchChange: (str) {

        },
        onSearchClose: () {
          controller.text = "";
          setState(() {
            searchBarOpen = false;
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          return TodoItemDisplay(Todo("$index"));
        },
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
    TextEditingController searchController,
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
      controller: searchController,
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
