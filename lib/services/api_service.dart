import 'package:arlex_getx/models/api_model.dart';
import 'package:arlex_getx/services/firebase_service.dart';
import 'package:arlex_getx/utils/custom_snackbar.dart';
import 'package:get/get.dart';

class ApiService extends GetxController {
  // static const geminiProApiKey = "AIzaSyCmZ-qk-LEnr0_uRqkdLTS8dMRA3W1nqEs";
  // static const docChatApiKey =
  //     "https://a6d5-2401-4900-54ed-4d2e-812-6f25-af60-be60.ngrok-free.app/chat";
  // static const uploadDocApiKey =
  //     "https://a6d5-2401-4900-54ed-4d2e-812-6f25-af60-be60.ngrok-free.app/upload_docs";
  // static const imageGenApiKey =
  //     "https://d8f5-103-94-57-212.ngrok-free.app/process_prompt";
  List<ApiModel> apiModel = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    final model = await getApisFromFirebase();
    apiModel.add(model);
  }

  Future<ApiModel> getApisFromFirebase() async {
    try {
      final doc =
          await FirebaseService.firestore.collection("APIs").doc('api').get();
      return ApiModel.fromMap(doc.data()!);
    } catch (e) {
      CustomSnackbar.showError("Error!", "Something went wrong!");
      return ApiModel(
          geminiApi: "", imageGenApi: "", uploadDocApi: "", chatWithDocApi: "");
    }
  }
}
