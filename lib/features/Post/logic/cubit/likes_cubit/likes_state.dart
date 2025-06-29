part of 'likes_cubit.dart';

sealed class LikesState  {
  const LikesState();

}

final class LikesInitial extends LikesState {}
final class LikesLoading extends LikesState {}
final class LikesLoaded extends LikesState {
   final int count;
   bool isLiked;

  LikesLoaded(this.count, this.isLiked);
}
final class LikesFailure extends LikesState {
  final String error;

  const LikesFailure(this.error);
}
