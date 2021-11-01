class UserModel {
  String name;
  String phone;
  String email;
  String uId;
  String profileImage;
  String address;
  String joinedAt;
  String createdAt;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.uId,
    this.joinedAt,
    this.createdAt,
    this.address,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    profileImage = json['profileImage'];
    joinedAt = json['joinedAt'];
    createdAt = json['createdAt'];
    address = json['address'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'profileImage': profileImage,
      'joinedAt': joinedAt,
      'createdAt': createdAt,
      'address': address,
    };
  }
}
