import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/Components/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseLocalNotification {
  static final FirebaseLocalNotification _instance =
      FirebaseLocalNotification._internal();
  factory FirebaseLocalNotification() => _instance;
  FirebaseLocalNotification._internal();
  static const String notificationKey = "notifications_enabled";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    log("Token: $token");
    handleBackground();
    handleForeground();
  }

  Future<void> saveNotificationSetting(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationKey, isEnabled);
  }

  Future<bool> getNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationKey) ?? true; // افتراضي شغال
  }

  Future<void> handleMessages(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? "null");
  }

  void handleForeground() {
    _foregroundSubscription?.cancel(); // cancel the old listener

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final isEnabled = await getNotificationSetting();
      if (isEnabled) {
        final title = message.notification?.title ?? message.data['title'];
        final body = message.notification?.body ?? message.data['body'];

        LocalNotification().showBasicNotification(title, body);
        log("notification received");
      } else {
        log("notification disabled");
      }
    });
  }

  void handleBackground() {
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      await Firebase.initializeApp();

      final prefs = await SharedPreferences.getInstance();
      final isEnabled =
          prefs.getBool(FirebaseLocalNotification.notificationKey) ?? true;

      if (!isEnabled) {
        log("notification disabled (background)");
        return;
      }

      final title = message.data['title'];
      final body = message.data['body'];

      LocalNotification().showBasicNotification(
        title ,
        body ,
      );
    });
  }

  Future<String> getAccessToken() async {
    final jsonString = await rootBundle.loadString(
      "assets/demosocialapp-ef38c-be73771d867a.json",
    );
    final clientCredentials = auth.ServiceAccountCredentials.fromJson(
      jsonString,
    );

    final scopes = ["https://www.googleapis.com/auth/firebase.messaging"];
    final client = await auth.clientViaServiceAccount(
      clientCredentials,
      scopes,
    );
    return client.credentials.accessToken.data;
  }

  Future<void> sendPushNotification({
    required String deviceToken,
    required String follower,
  }) async {
    String accessToken = await getAccessToken();
    final url = Uri.parse(
      "https://fcm.googleapis.com/v1/projects/demosocialapp-ef38c/messages:send",
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = jsonEncode({
      "message": {
        "token": deviceToken,
        "data": {
          "title": "New Follower!",
          "body": "Ahmed started following you",
          "type": "follow",
        },
      },
    });

    final response = await http.post(url, headers: headers, body: body);

    log('Status: ${response.statusCode}');
    log('Body: ${response.body}');
  }
}
