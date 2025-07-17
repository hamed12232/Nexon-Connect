import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserStatusTracker extends StatefulWidget {
  const UserStatusTracker({super.key});

  @override
  State<UserStatusTracker> createState() => _UserStatusTrackerState();
}

class _UserStatusTrackerState extends State<UserStatusTracker>
    with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("App Ready");
    });
    WidgetsBinding.instance.addObserver(this); // Start observing lifecycle
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop observing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
