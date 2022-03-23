class PostModel {
  late String name;
  late String uId;
  late String postImage;
  late String date;
  late String text;
  late String image;

  PostModel({
    required this.name,
    required this.uId,
    required this.postImage,
    required this.date,
    required this.text,
    required this.image,
  });
  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    postImage = json['postImage'];
    date = json['date'];
    image = json['image'];
    text = json['text'];
    image = json['image'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'postImage': postImage,
      'date': date,
      'image': image,
      'text': text,
    };
  }
}
