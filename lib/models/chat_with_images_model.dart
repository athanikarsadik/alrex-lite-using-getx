import 'dart:typed_data';


class ChatWithImagesModel{
  final List<Uint8List>? images;
  final String? prompt;
  final String? response;
  final String role;

  ChatWithImagesModel({required this.images, required this.prompt, required this.response, required this.role});
}