import 'package:flutter/material.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo['title'];
      descriptionController.text = todo['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Todo' : 'Add ToDo'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
              maxLines: 8,
              minLines: 5,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(isEdit ? 'update' : 'Submit'),
                ))
          ],
        ));
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      showErrorMessage(context, message: "todo data is null");
      return;
    }

    String id = todo['_id'];

    final isSuccess = await TodoService.updateTodo(id, body);

    if (isSuccess) {
      showMessage(context, message: "data updated successful");
      titleController.text = '';
      descriptionController.text = '';
    } else {
      showErrorMessage(context, message: 'failed to save data!');
    }
  }

  Future<void> submitData() async {


    final isSuccess = await TodoService.createTodo(body);

    if (isSuccess) {
      print('data upload successfully');
      showMessage(context, message: "data saved successful");
      titleController.text = '';
      descriptionController.text = '';
    } else {
      print('failed to save data');
      showErrorMessage(context, message: 'failed to save data!');
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }
}
