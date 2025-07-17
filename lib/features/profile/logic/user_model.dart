class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String image;
  final List followers;
  final List following;
  final int likes;
  final bool online;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.image,
    required this.followers,
    required this.following,
    required this.likes,
    
    required this.online,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      fullName: map['fullName'],
      email: map['email'],
      image: map['image'],
      followers: map['followers'] ?? [],
      following: map['following'] ?? [],
      likes: map['likes'] ?? 0, 
      online: map['online'] ?? false,

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
      'online': online,
    };
  }
}
