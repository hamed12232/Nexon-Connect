import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/core/helper/firebase_helper.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.firebaseHelper) : super(AuthInitial());

  final FirebaseHelper firebaseHelper;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await firebaseHelper.loginUser(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await firebaseHelper.registerUser(email, password, name);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
