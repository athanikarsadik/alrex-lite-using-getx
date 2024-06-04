import 'dart:convert';
import 'dart:io';
import 'package:arlex_getx/controller/home_screen_controller.dart';
import 'package:arlex_getx/models/chat_model.dart';
import 'package:arlex_getx/models/title_model.dart';
import 'package:arlex_getx/services/api_service.dart';
import 'package:arlex_getx/services/firebase_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeScreenService {
  Future<String> getImageService(String prompt) async {
    try {
      print("hey");
      print("${Get.find<ApiService>().apiModel[0].imageGenApi}");
      final response = await http.post(
        Uri.parse(Get.find<ApiService>().apiModel[0].imageGenApi),
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
        Uri.parse(Get.find<ApiService>().apiModel[0].uploadDocApi),
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
        Uri.parse(Get.find<ApiService>().apiModel[0].chatWithDocApi),
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

  Future<void> saveChatsToFirebase(
      List<ChatDataModel> chats, String title, String docId) async {
    try {
      final List<Map<String, dynamic>> chatMaps =
          chats.map((chat) => chat.toMap()).toList();
      final uid = FirebaseService.auth.currentUser!.uid;
      if (docId == "") {
        // Create a new document with a unique ID
        final docref = await FirebaseService.firestore
            .collection("Users")
            .doc(uid)
            .collection("Chat History")
            .add({'chat': chatMaps, 'title': title, 'time': DateTime.now()});

        Get.find<HomeScreenController>().curDocId = docref.id;
      } else {
        //update previous doc
        // Create a new document with a unique ID
        await FirebaseService.firestore
            .collection("Users")
            .doc(uid)
            .collection("Chat History")
            .doc(docId)
            .update({'chat': chatMaps, 'title': title, 'time': DateTime.now()});
      }
    } catch (e) {
      print('Error saving chats to Firebase: $e');
      rethrow; // Rethrow for further handling if needed
    }
  }

  Future<List<TitleModel>> getChatTitlesForSideBar() async {
    try {
      final uid = FirebaseService.auth.currentUser!.uid;
      final querySnapshot = await FirebaseService.firestore
          .collection("Users")
          .doc(uid)
          .collection("Chat History")
          .get();

      final chats = querySnapshot.docs;
      List<TitleModel> titles = [];
      chats.forEach((chatDoc) {
        final data = TitleModel.fromMap(chatDoc.data(), chatDoc.id);
        titles.add(data);
      });
      // querySnapshot.docs.map((doc) => ChatDataModel.fromMap(doc)).toList();
      return titles;
    } catch (e) {
      print('Error fetching chats from Firebase: $e');
      rethrow; // Rethrow for further handling if needed
    }
  }

  Future<List<ChatDataModel>> getChatHistoryByDocId(
      {required String docId}) async {
    try {
      final uid = FirebaseService.auth.currentUser!.uid;
      final querySnapshot = await FirebaseService.firestore
          .collection("Users")
          .doc(uid)
          .collection("Chat History")
          .doc(docId)
          .get();
      List<ChatDataModel> chatList = [];
      if (querySnapshot.exists) {
        List<dynamic> chats = querySnapshot.data()!['chat'];
        chats.forEach((chat) {
          chatList.add(ChatDataModel.fromMap(chat));
        });
      }
      return chatList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseService.auth.signOut();
      print("Successfully signed out!");
    } catch (e) {
      print("Error signing out: e");
      // Handle errors appropriately, e.g., show a snackbar to the user
    }
  }
}
