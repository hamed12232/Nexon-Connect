import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String text;
  final DateTime? timestamp;
  final String? repliedToMessageId;
  final String? repliedToText;
  final String? repliedToSenderId;
  final bool isRead; // Only add this field

  MessageModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.repliedToMessageId,
    this.repliedToText,
    this.repliedToSenderId,
    this.isRead = false, // Default value for isRead
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      repliedToMessageId: json['repliedToMessageId'],
      repliedToText: json['repliedToText'],
      repliedToSenderId: json['repliedToSenderId'],
      isRead: json['isRead'] ?? false, // Default to false if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'repliedToMessageId': repliedToMessageId,
      'repliedToText': repliedToText,
      'repliedToSenderId': repliedToSenderId,
      'isRead': isRead, // Include isRead in the JSON representation
    };
  }
}
