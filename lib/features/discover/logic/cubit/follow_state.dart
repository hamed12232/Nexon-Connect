part of 'follow_cubit.dart';

abstract class FollowState {}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class FollowLoaded extends FollowState {
  final List<DocumentSnapshot> users;
  final List<String> following;

  FollowLoaded({required this.users, required this.following});
}

class FollowFailure extends FollowState {
  final String error;
  FollowFailure(this.error);
}
