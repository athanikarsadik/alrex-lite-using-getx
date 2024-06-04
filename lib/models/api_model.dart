class ApiModel {
  final String geminiApi;
  final String imageGenApi;
  final String uploadDocApi;
  final String chatWithDocApi;

  ApiModel(
      {required this.geminiApi,
      required this.imageGenApi,
      required this.uploadDocApi,
      required this.chatWithDocApi});

  factory ApiModel.fromMap(Map<String, dynamic> map) {
    return ApiModel(
      geminiApi: map['gemini_api'] as String,
      imageGenApi: map['image_gen_api'] as String,
      uploadDocApi: map['doc_upload_api'] as String,
      chatWithDocApi: map['chat_with_doc_api'] as String,
    );
  }
}
