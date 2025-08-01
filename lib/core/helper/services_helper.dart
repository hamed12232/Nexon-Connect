import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexon/features/profile/logic/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class ServicesHelper {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final SupabaseClient supabase = Supabase.instance.client;

  static final ServicesHelper _instance = ServicesHelper._internal();
  factory ServicesHelper() => _instance;
  ServicesHelper._internal();

  Future loginUser(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String> registerUser(String email, String password) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = userCredential.user!.uid;
    return uid;
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future<UserModel> getUser(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, uid);
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> updateUserImage(String uid, String imageUrl) async {
    await firestore.collection('users').doc(uid).update({'image': imageUrl});
  }

  Future<void> sendResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final user = auth.currentUser;

      if (user == null) {
        return false;
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      return true;
    } on FirebaseAuthException catch (e) {
      print("Firebase Error: ${e.code}");
      return false;
    } catch (e) {
      print("Unknown Error: $e");
      return false;
    }
  }

  Future<void> deleteAccount(User? user) async {
    try {
      if (user == null) {
        log("User is null");
        return;
      }

      await user.delete();
      await firestore.collection("users").doc(user.uid).delete();

      log("Account deleted successfully");
    } catch (e) {
      log("Error deleting account: ${e.toString()}");
    }
  }

  Future<void> updateProfile(
    String name,
    String phoneNumber,
    String address,
  ) async {
    try {
      await firestore.collection('users').doc(auth.currentUser!.uid).update({
        'fullName': name,
        'phoneNumber': phoneNumber,
        'address': address,
      });
      log("Profile updated successfully");
    } catch (e) {
      log("Error updating profile: $e");
      rethrow; // لو حبيت ترجع الخطأ لباقي الكود
    }
  }

  // Future<void> verficationUser() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null && !user.emailVerified) {
  //     await user.sendEmailVerification();
  //   }
  // }

  Future<bool> isEmailRegistered(String email) async {
    try {
      List<String> signInMethods =
          // ignore: deprecated_member_use
          await auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty; // إذا كان غير فارغ، فالإيميل مسجل
    } catch (e) {
      return false; // في حالة أي خطأ، نعتبر أن الإيميل غير مسجل
    }
  }

  Future<String?> uploadImage(File imageFile, String fileName) async {
    final bucket = supabase.storage.from('images');
    try {
      final path = 'uploads/$fileName';

      final response = await bucket.upload(
        path,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );

      if (response.isEmpty) throw Exception("Upload failed");

      // احصل على الرابط العلني للصورة بعد رفعها
      final publicUrl = bucket.getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      print("Upload Error: ${e.toString()}");
      return null;
    }
  }

  // Future<bool> isEmailExistsInFirestore(String email) async {
  //   final query = await firestore
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .limit(1)
  //       .get();
  //   return query.docs.isNotEmpty;
  // }
}
