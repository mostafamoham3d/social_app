class MessageModel {
  late String dateTime;
  late String text;
  late String receiverId;
  late String senderId;

  MessageModel({
    required this.dateTime,
    required this.text,
    required this.receiverId,
    required this.senderId,
  });
  MessageModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    text = json['text'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'text': text,
      'receiverId': receiverId,
      'senderId': senderId,
    };
  }
}
