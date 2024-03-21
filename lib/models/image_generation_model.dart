// ignore_for_file: public_member_api_docs, sort_constructors_first

class ImageGenerationModel {
  final String? imageB64;
  final String? prompt;
  final String role;

  ImageGenerationModel({this.imageB64, this.prompt, required this.role});

    factory ImageGenerationModel.fromMap(Map<String, dynamic> map) {
    return ImageGenerationModel(
      imageB64: map['imageB64'] != null ? map['imageB64'] as String : null,
      prompt: map['prompt'] != null ? map['prompt'] as String : null,
      role: map['role'] as String,
    );
  }
}
