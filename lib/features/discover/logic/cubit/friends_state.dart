part of 'friends_cubit.dart';

abstract class FriendState {}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<UserModel> allUsers;
  final UserModel currentUser;

  FriendLoaded({required this.allUsers, required this.currentUser});
}

class FriendFailure extends FriendState {
  final String error;
  FriendFailure(this.error);
}
