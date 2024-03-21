import 'dart:convert';
import 'dart:io';
import 'package:arlex_getx/constants/secrets.dart';
import 'package:http/http.dart' as http;

class HomeScreenService {
  Future<String> getImageService(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(
            Secrets.imageGenApiKey),
        body: jsonEncode(<String, String>{
          'prompt': prompt,
        }), // Encode the request body as JSON
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Exception: $e');
      throw e.toString();
    }
  }

  Future<bool> uploadDocsToServer(List<File> docs) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            Secrets.uploadDocApiKey),
      );
      for (var file in docs) {
        request.files
            .add(await http.MultipartFile.fromPath('documents', file.path));
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> chatWithDocService(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(
            Secrets.docChatApiKey),
        body: jsonEncode(<String, String>{
          'query': prompt,
        }), // Encode the request body as JSON
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('Exception: $e');
      throw e.toString();
    }
  }
}
