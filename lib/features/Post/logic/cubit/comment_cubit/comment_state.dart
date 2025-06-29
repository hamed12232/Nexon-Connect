// comment_state.dart
part of 'comment_cubit.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentModel> comments;
  CommentLoaded(this.comments);
}

class CommentFailure extends CommentState {
  final String error;
  CommentFailure(this.error);
}
