import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/Components/local_notification.dart';
import 'package:myapp/core/helper/cache_helper.dart';
import 'package:myapp/core/helper/cache_helper_key.dart';

class FirebaseNotification {
  static final FirebaseNotification _instance =
      FirebaseNotification._internal();
  factory FirebaseNotification() => _instance;
  FirebaseNotification._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    log("Token: $token");
    handleForeground();
  }

  Future<void> saveNotificationSetting(bool isEnabled) async {
    await CachHelper().saveData(
      key: CacheHelperKey.notificationKey,
      value: isEnabled,
    );
  }

  Future<bool> getNotificationSetting() async {
    return await CachHelper().getData(key: CacheHelperKey.notificationKey) ??
        true; // افتراضي شغال
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
    required String title,
    required String bodye,
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
        "notification": {
          "title": title,
          "body": bodye,
        },
        "android": {
          "priority": "high",
          "notification": {
            "title": title,
            "body": bodye,
            "channel_id": "messages",
            "notification_priority": "PRIORITY_HIGH",
            "default_sound": true,
            "default_vibrate_timings": true,
          }
        },
        "data": {
          "title": title,
          "body": bodye,
          "type": "message",
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        },
        "apns": {
          "headers": {
            "apns-priority": "10"
          },
          "payload": {
            "aps": {
              "alert": {
                "title": title,
                "body": bodye
              },
              "badge": 1,
              "sound": "default"
            }
          }
        }
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    log('Status: ${response.statusCode}');
    log('Body: ${response.body}');
  }
}
