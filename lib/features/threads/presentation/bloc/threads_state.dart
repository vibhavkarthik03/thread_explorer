import 'package:thread_explorer/features/threads/data/models/comment.dart';

abstract class ThreadState {}

class ThreadLoading extends ThreadState {}

class ThreadLoaded extends ThreadState {
  final List<Comment> visibleComments;
  ThreadLoaded(this.visibleComments);
}
