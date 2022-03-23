class AuthUserModel {
  late String name;
  late String email;
  late String phone;
  late String uId;
  late String image;
  late String cover;
  late String bio;

  AuthUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.image,
    required this.cover,
    required this.bio,
  });
  AuthUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'cover': cover,
      'bio': bio,
      'phone': phone,
      'uId': uId,
    };
  }
}
