class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String image;
  final int followers;
  final int following;
  final int likes;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.image,
    required this.followers,
    required this.following,
    required this.likes,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      fullName: map['fullName'],
      email: map['email'],
      image: map['image']  ,
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      likes: map['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'image': image,
      'followers': followers,
      'following': following,
      'likes': likes,
    };
  }
  
}
