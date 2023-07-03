import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<bool> deleteById(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchToto() async {
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      return json['items'] as List;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodo(String id, Map body) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 200;
  }

  static Future<bool> createTodo(Map body) async {
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 201;
  }
}
