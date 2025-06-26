class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userImage;
  final String? text;
  final String? postImage;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> comments;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.text,
    required this.postImage,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'],
      userImage: json['user_image'],
      text: json['text'],
      postImage: json['post_image'],
      createdAt: DateTime.parse(json['created_at']),
      likes: List<String>.from(json['likes']),
      comments: List<String>.from(json['comments']),
    );
  }
}
