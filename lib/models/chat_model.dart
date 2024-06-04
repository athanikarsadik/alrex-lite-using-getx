class ChatDataModel {
  final String query;
  final String response;

  ChatDataModel({
    required this.query,
    required this.response,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'query': query,
      'response': response,
    };
  }

  factory ChatDataModel.fromMap(Map<String, dynamic> map) {
    return ChatDataModel(
      query: map['query'] as String,
      response: map['response'] as String,
    );
  }
}
