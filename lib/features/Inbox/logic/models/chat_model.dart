import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String chatId;
  final List<String> users;
  final String lastMessage;
  final DateTime lastTime;
  final String senderName;
  final String senderImage;
  final bool isActive;
  final int unreadCount; // Only add this field

  ChatModel({
    required this.chatId,
    required this.users,
    required this.senderName,
    required this.senderImage,
    required this.lastMessage,
    required this.lastTime,
    required this.isActive,
    this.unreadCount = 0, // Default value for unreadCount
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'],
      users: List<String>.from(json['users']),
      lastMessage: json['lastMessage'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
      lastTime: (json['lastTime'] as Timestamp).toDate(),
      isActive: json['isActive'],
      unreadCount: json['unreadCount'] ?? 0, // Default to 0 if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'users': users,
      'lastMessage': lastMessage,
      'senderName': senderName,
      'senderImage': senderImage,
      'lastTime': lastTime,
      'isActive': isActive,
      'unreadCount': unreadCount,
    };
  }
}
