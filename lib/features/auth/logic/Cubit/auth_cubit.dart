import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/core/helper/services_helper.dart';
import 'package:myapp/features/profile/logic/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  ServicesHelper servicesHelper = ServicesHelper();
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await servicesHelper.loginUser(email, password);
      final token = await FirebaseMessaging.instance.getToken();
      //save token
      await servicesHelper.firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"fcmToken": token});
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailure('user-not-found'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailure("wrong-password"));
      } else {
        emit(AuthFailure('unknown error'));
      }
    } catch (e) {
      emit(AuthFailure('other error'));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      String uid = await servicesHelper.registerUser(email, password);
      final newUser = UserModel(
        uid: uid,
        fullName: name,
        image:
            "https://phjbtfqjmlkwoooavnfb.supabase.co/storage/v1/object/public/images/uploads/guestImage.avif",
        email: email,
        followers: [],
        following: [],
        likes: 0,
        online: false,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap());
      final token = await FirebaseMessaging.instance.getToken();
      await servicesHelper.firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"fcmToken": token});
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure('weak-password'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthFailure("email-already-in-use"));
      } else {
        emit(AuthFailure('unknown error'));
      }
    } catch (e) {
      emit(AuthFailure('other error'));
    }
  }

  Future<void> getUserData(String uid) async {
    emit(AuthLoading());
    try {
      UserModel user = await servicesHelper.getUser(uid);
      emit(AuthUserLoaded(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> updateName(String newName) async{
    emit(AuthLoading());
    try {
     await servicesHelper.firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"fullName": newName});
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
