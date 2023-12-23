import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

//  Enter Your open AI API_KEY
String apikey = "Enter Here API_KEY";

class Api {
  static const String _url = "https://api.openai.com/v1/images/generations";

  static Future<Map<String, dynamic>?> requestPost(
      {required String prompt}) async {
    debugPrint("prompt : $prompt");
    try {
      final response = await post(Uri.parse(_url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $apikey"
          },
          body: jsonEncode({
            "model": "dall-e-3",
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
          }));

      debugPrint("response 2 : ${response.body}");
      if (response.statusCode == 200) {
        debugPrint(response.body);
        final json = jsonDecode(response.body);
        return json['data'][0];
      }
      return null;
    } on HttpException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }
}
