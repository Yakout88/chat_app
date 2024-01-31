class MessageModel {
  final String messages;
  final String email;

  MessageModel({required this.email, 
    required this.messages,
  });
  factory MessageModel.fromJson(map) {
    return MessageModel(email: map["email"], messages: map["messages"],);
  }
}
