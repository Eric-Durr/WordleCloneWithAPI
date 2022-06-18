import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'dart:convert';

import 'package:xml2json/xml2json.dart';

class ApiConstants {
  static String baseUrl =
      'https://palabras-aleatorias-public-api.herokuapp.com';
  static String fiveWordEndpoint = '/random-by-length?length=5';
}

Future<String> fetchRandomFiveLetterWord() async {
  var redo = true;
  var responseJSON;
  final Xml2Json xml2Json = Xml2Json();
  while (redo) {
    final response = await http.get(Uri.parse(
        'https://clientes.api.greenborn.com.ar/public-random-word?c=1&l=5'));
    responseJSON = jsonDecode(response.body);
    final alpha = RegExp(r'^[a-zA-Z]+$');
    redo = !alpha.hasMatch(responseJSON[0]);
  }
  return responseJSON[0];
}
