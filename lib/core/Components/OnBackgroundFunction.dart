import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:myapp/core/Components/local_notification.dart';
import 'package:myapp/core/helper/cache_helper.dart';
import 'package:myapp/core/helper/cache_helper_key.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final isEnabled =
      await CachHelper().getData(key: CacheHelperKey.notificationKey) ?? true;

  if (!isEnabled) {
    log("notification disabled (background)");
    return;
  }

  final title = message.data['title'] ?? "No title";
  final body = message.data['body'] ?? "No body";

  LocalNotification().showBasicNotification(title, body);
}
