import 'package:edet/core/errors/exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> sendGetRequest(String _authority, String _unencodedPath,
    Map<String, dynamic> _parameters) async {
  final Uri url = Uri.https(_authority, _unencodedPath, _parameters);
  try {
    final response = await http.get(url);
    return response;
  } on Exception {
    throw NetworkException();
  }
}

Future<http.Response> sendPostRequest(
    String _authority,
    String _unencodedPath,
    Map<String, dynamic> _parameters,
    Map<String, String> headers,
    Map<String, dynamic> json) async {
  final Uri url = Uri.https(_authority, _unencodedPath, _parameters);
  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(json),
    );
    return response;
  } on Exception {
    throw NetworkException();
  }
}
