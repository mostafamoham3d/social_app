class MessageWithImageModel {
  late String dateTime;
  late String image;
  late String receiverId;
  late String senderId;

  MessageWithImageModel({
    required this.dateTime,
    required this.image,
    required this.receiverId,
    required this.senderId,
  });
  MessageWithImageModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    image = json['image'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'image': image,
      'receiverId': receiverId,
      'senderId': senderId,
    };
  }
}
