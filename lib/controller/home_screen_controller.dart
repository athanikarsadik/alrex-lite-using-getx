// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arlex_getx/models/chat_with_images_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

import 'package:arlex_getx/models/image_generation_model.dart';
import 'package:arlex_getx/services/home_screen_service.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../models/chat_with_doc_model.dart';

class HomeScreenController extends GetxController {
  final gemini = Gemini.instance;

  RxList<Content> chats = <Content>[].obs;
  RxList<ImageGenerationModel> generatedImages = <ImageGenerationModel>[].obs;
  RxList<ChatWithImagesModel> imageChats = <ChatWithImagesModel>[].obs;
  RxList<ChatWithDocModel> docChats = <ChatWithDocModel>[].obs;

  RxList<Uint8List> selectedImages = <Uint8List>[].obs;
  RxList<File> selectedDocuments = <File>[].obs;

  final TextEditingController inputChatController = TextEditingController();
  final TextEditingController inputImageGenController = TextEditingController();
  final TextEditingController inputChatWithImgController =
      TextEditingController();
  final TextEditingController inputDocController = TextEditingController();

  List<String> pagesString = [
    "ChatBot",
    "Generate AI Images",
    "Chat with Images",
    "Chat With Doc",
  ];
  RxString selectedScreenTitle = "ChatBot".obs;

  RxBool loading = false.obs;
  RxBool streamingData = false.obs;
  RxBool generatingImages = false.obs;
  RxBool streamingImageChat = false.obs;
  RxBool streamingDocChat = false.obs;

  final ScrollController chatScrollController = ScrollController();
  final ScrollController imageGenerationScrollController = ScrollController();
  final ScrollController chatImagesScrollController = ScrollController();
  final ScrollController chatDocScrollController = ScrollController();

  final HomeScreenService homeScreenService;

  HomeScreenController({
    required this.homeScreenService,
  });

  scrollToBottomChat() {
    try {
      chatScrollController
          .jumpTo(chatScrollController.position.maxScrollExtent);
    } catch (e) {
      print(e);
    }
  }

  scrollToBottomImageGen() {
    try {
      imageGenerationScrollController
          .jumpTo(imageGenerationScrollController.position.maxScrollExtent);
    } catch (e) {
      print(e);
    }
  }

  scrollToBottomImageChat() {
    try {
      chatImagesScrollController
          .jumpTo(chatImagesScrollController.position.maxScrollExtent);
    } catch (e) {
      print(e);
    }
  }

  scrollToBottomDocChat() {
    try {
      chatDocScrollController
          .jumpTo(chatDocScrollController.position.maxScrollExtent);
    } catch (e) {
      print(e);
    }
  }

  void chatbotGetResponse() {
    if (inputChatController.text.trim() == "") {
      return;
    }
    streamingData.value = true;
    try {
      final searchedText = inputChatController.text.trim();
      chats.add(Content(role: 'user', parts: [Parts(text: searchedText)]));
      update();
      inputChatController.clear();

      gemini.streamChat(chats).listen((value) {
        loading.value = false;
        update();
        scrollToBottomChat();
        if (chats.isNotEmpty && chats.last.role == value.content?.role) {
          chats.last.parts!.last.text =
              '${chats.last.parts!.last.text}${value.output}';
        } else {
          chats.add(Content(role: 'model', parts: [Parts(text: value.output)]));
        }
      }, onDone: () {
        scrollToBottomChat();
        streamingData.value = false;
      });
    } catch (e) {
      streamingData.value = false;
      if(chats.last.role == 'user'){
        chats.removeLast();
      }
      Get.snackbar(
        'Error',
        'An error occurred please try again',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> imageGenGetResponse() async {
    final prompt = inputImageGenController.text.trim();
    inputImageGenController.clear();
    if (prompt == "") {
      return;
    }
    generatedImages.add(ImageGenerationModel(role: "user", prompt: prompt));
    scrollToBottomImageGen();
    update();
    generatingImages.value = true;
    try {
      generatedImages
          .add(ImageGenerationModel(role: "loading", imageB64: '', prompt: ''));
      update();
      final imageData = await homeScreenService.getImageService(prompt);
      final data = jsonDecode(imageData);
      generatedImages.removeLast();
      update();
      generatedImages.add(ImageGenerationModel(
          role: "model", imageB64: data['imageB64'] as String, prompt: prompt));
      generatingImages.value = false;
      scrollToBottomImageGen();
      saveImageToGallery(data['imageB64']);
      update();
    } catch (e) {
      generatingImages.value = false;
      generatedImages.removeLast();
      update();
      Get.snackbar(
        'Error',
        'An error occurred please try again',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> imagechatResponse() async {
    streamingImageChat.value = true;
    final prompt = inputChatWithImgController.text.trim();
    inputChatWithImgController.text = "";
    try {
      if (prompt == "" && selectedImages.isNotEmpty) {
        imageChats.add(ChatWithImagesModel(
            images: List.from(selectedImages),
            prompt: "Describe the following images",
            response: '',
            role: 'user'));
        update();
        imageChats.add(ChatWithImagesModel(
            images: [], prompt: "", response: '', role: 'loading'));
        update();
        scrollToBottomImageChat();
        final result = await gemini.textAndImage(
          text: "Describe the images?",
          images: List.from(selectedImages),
        );
        imageChats.removeLast();
        update();
        imageChats.add(ChatWithImagesModel(
            images: [],
            prompt: "",
            response: result?.content?.parts?.last.text ?? 'error',
            role: 'model'));
      } else if (prompt != "") {
        imageChats.add(ChatWithImagesModel(
            images: List.from(selectedImages),
            prompt: prompt,
            response: '',
            role: 'user'));
        update();
        imageChats.add(ChatWithImagesModel(
            images: [], prompt: "", response: '', role: 'loading'));
        update();
        scrollToBottomImageChat();
        final result = await gemini.textAndImage(
          text: prompt,
          images: List.from(selectedImages),
        );
        imageChats.removeLast();
        update();
        imageChats.add(ChatWithImagesModel(
            images: [],
            prompt: "",
            response: result?.content?.parts?.last.text ?? 'error',
            role: 'model'));
      } else {
        return;
      }
    } catch (e) {
      imageChats.removeLast();
      imageChats.removeLast();
      update();
      Get.snackbar(
        'Error',
        'An error occurred please try again',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    streamingImageChat.value = false;
    update();
    selectedImages.clear();
    scrollToBottomImageChat();
  }

  void saveImageToGallery(String base64Image) async {
  // Decode Base64
  Uint8List bytes = base64Decode(base64Image);

  // Get external storage directory
  Directory? directory = await getExternalStorageDirectory();

  // Create a unique filename
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String path = '${directory!.path}/image_$timestamp.jpg';

  // Save image to file
  File(path).writeAsBytesSync(bytes);
  print('file saved');
  // Save image to the gallery
  await ImageGallerySaver.saveFile(path);
}

  Future<void> chatwithDocGetRespose() async {
    final prompt = inputDocController.text.trim();
    inputDocController.text = "";
    streamingDocChat.value = true;
    if (prompt == "") {
      return;
    }
    try {
      docChats.add(ChatWithDocModel(prompt: prompt, role: "user"));
      update();
      scrollToBottomDocChat();

      final result = await homeScreenService.chatWithDocService(prompt);
      final data = jsonDecode(result);
      docChats.add(ChatWithDocModel(
          prompt: '', role: "model", response: data['response']));
      update();
      scrollToBottomDocChat();
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred please try again',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      streamingDocChat.value = false;
    }
    streamingDocChat.value = false;
  }

  Future<bool> uploadDocs() async {
    streamingDocChat.value = true;
    try {
      bool res = await homeScreenService.uploadDocsToServer(selectedDocuments);
      streamingDocChat.value = false;
      return res;
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred please try again',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      streamingDocChat.value = false;
      return false;
    }
  }
}
