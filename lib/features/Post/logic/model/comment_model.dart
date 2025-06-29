import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String username;
  final String userImage;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'username': username,
        'userImage': userImage,
        'text': text,
        'createdAt': createdAt,
      };

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
        id: map['id'],
        userId: map['userId'],
        username: map['username'],
        userImage: map['userImage'],
        text: map['text'],
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      );
}
