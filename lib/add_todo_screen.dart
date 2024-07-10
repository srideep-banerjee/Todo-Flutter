import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:todo/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late TextEditingController titleController, descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: "");
    descriptionController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
            ),
            onPressed: () {
              if (titleController.text == "") return;
              int index = localStorage.length;
              String? description = descriptionController.text;
              if (description == "") description = null;
              Todo todo = Todo(index, titleController.text, description);
              localStorage.setItem("${localStorage.length}", todo.toJSON());
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TitleText(titleController),
            const Divider(),
            Expanded(
              child: DescriptionText(descriptionController),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {

  final TextEditingController controller;

  const TitleText(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      expands: false,
      controller: controller,
      decoration: const InputDecoration.collapsed(
        hintText: "Enter title",
        hintStyle: TextStyle(fontWeight: FontWeight.normal)
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w700
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {

  final TextEditingController controller;

  const DescriptionText(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      expands: false,
      controller: controller,
      decoration: const InputDecoration.collapsed(
        hintText: "Enter description",
      ),
    );
  }
}