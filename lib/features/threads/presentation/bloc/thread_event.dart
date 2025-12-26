import 'package:thread_explorer/features/threads/data/models/comment.dart';

abstract class ThreadEvent {}

class LoadThread extends ThreadEvent {
  final int storyId;

  LoadThread({required this.storyId});
}

class ToggleExpand extends ThreadEvent {
  final Comment comment;
  ToggleExpand(this.comment);
}
