import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/Components/local_notification.dart';

class FirebaseLocalNotification {
  static final FirebaseLocalNotification _instance =
      FirebaseLocalNotification._internal();
  factory FirebaseLocalNotification() => _instance;
  FirebaseLocalNotification._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    log("Token: $token");
    FirebaseMessaging.onBackgroundMessage(handleMessages);
    handleForeground();
  }

  Future<void> handleMessages(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? "null");
  }

  void handleForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification().showBasicNotification(message);
    });
  }

  Future<void> sendFollowNotificationToUser(
    String targetUserId,
    String followerName,
  ) async {
    final serverUrl =
        'https://fcm.googleapis.com/v1/projects/demosocialapp-ef38c/messages:send'; // رابط السيرفر بتاعك

    final body = {
      "toUserId": targetUserId,
      "title": "$followerName started following you",
      "body": "Tap to view their profile",
    };

    try {
      final response = await http.post(Uri.parse(serverUrl), body: body);

      if (response.statusCode == 200) {
        log("Notification sent successfully");
      } else {
        log("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      log("Error: $e");
    }
  }
}
