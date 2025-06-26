import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/profile/logic/user_model.dart';

class FirebaseHelper {


  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future loginUser(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    
  }
Future<void> registerUser(String email, String password, String username) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final uid = userCredential.user!.uid;

    final newUser = UserModel(
      uid: uid,
      fullName: username,
      image: "assets/images/guestImage.avif",
      email: email,
      
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(newUser.toMap());

    // Navigate to HomeScreen or show success message
  } catch (e) {
    print("Registration failed: $e");
    // Handle error
  }
}
  

  Future signOut() async {
    await auth.signOut();
  }


  Future<void> verficationUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

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



}
