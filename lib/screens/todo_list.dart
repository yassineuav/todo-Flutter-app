import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todo/services/todo_service.dart';
import 'package:todo/utils/snackbar_helper.dart';
import 'package:todo/widget/todo_card.dart';


class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {

  bool isLoading = true;
  List items = [];
  @override
  void initState(){
    super.initState();
    fetchToto();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('To Do List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchToto,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                  'No ToDo Item',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            child: ListView.builder(
              itemCount: items.length,
                padding: const EdgeInsets.all(5),
                itemBuilder: (context, index){
                final item = items[index] as Map;
                  return TodoCard(index: index, item: item, navigateEdit: navigateToEditPage, deleteById: deleteById);
                }),
          ),
        ),
        child : const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: navigateToAddPage, label: Text('Add')),
    );
  }


  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });

    fetchToto();
  }

    Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(todo:item),);
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });

    fetchToto();
  }

  Future<void> fetchToto() async {

    final response = await TodoService.fetchToto();

    if(response != null){
      setState(() {
        items = response;
      });
    }else{
      showErrorMessage(context, message: 'something went wrong!!');
    }
    
    setState(() {
      isLoading = false;
    });

  }

  Future<void> deleteById(String id) async {

    final isSuccess = await TodoService.deleteById(id);

    if(isSuccess){
      showMessage(context, message: 'item deleted successfully');
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }else {
      showErrorMessage(context, message: 'something went wrong!!!!');
    }

  }


}
