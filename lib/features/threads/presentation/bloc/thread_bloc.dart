import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thread_explorer/features/threads/data/models/comment.dart';
import 'package:thread_explorer/features/threads/data/repository/threads_remote_repository.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/thread_event.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/thread_state.dart';

class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  late Comment rootComment;
  final List<Comment> visible = [];

  ThreadBloc() : super(ThreadLoading()) {
    on<LoadThread>(_onLoad);
    on<ToggleExpand>(_onToggle);
  }

   Future<void> _onLoad(LoadThread event, Emitter emit) async {
    final threadsRepo = ThreadsRemoteRepository();
    rootComment = await threadsRepo.getCommentsForStory(storyId: event.storyId);
    // added clear as precaution to avoid duplicates (if any)
    visible
      ..clear()
      ..addAll(_flattenAll(rootComment));
    emit(ThreadLoaded(List.from(visible)));
  }

  void _onToggle(ToggleExpand event, Emitter emit) {

    // Ignore if no children
    if (event.comment.children.isEmpty) return;

    final comment = event.comment;
    comment.isExpanded = !comment.isExpanded;

    if (comment.isExpanded) {
      _expandComment(comment);
    } else {
      _collapseComment(comment);
    }

    emit(ThreadLoaded(List.from(visible)));
  }

  void _expandComment(Comment comment) {
    final parentIndex = visible.indexOf(comment);
    if (parentIndex == -1) return;

    final children = _flattenChildren(comment, comment.depth + 1);

    // children comments depth are +1 from their parent comment.
    visible.insertAll(parentIndex + 1, children);
  }

  void _collapseComment(Comment comment) {
    final startIndex = visible.indexOf(comment);
    if (startIndex == -1) return;

    int removeCount = 0;

    for (int i = startIndex + 1; i < visible.length; i++) {
      // Condition to make sure to not remove/collapse other comment's children
      // (depth will become same after visiting all children in current comment).
      if (visible[i].depth <= comment.depth) break;
      removeCount++;
    }

    visible.removeRange(startIndex + 1, startIndex + 1 + removeCount);
  }

  // Recursion done here for nested comments - whole list is prepared
  List<Comment> _flattenAll(Comment comment, {int depth = 0}) {
    comment.depth = depth;
    final list = <Comment>[comment];

    if (!comment.isExpanded) return list;

    for (final child in comment.children) {
      // Recursion by increasing the depth for nested comments
      list.addAll(_flattenAll(child, depth: depth + 1));
    }

    return list;
  }

  // Recursion done here for nested comments - only for the toggled comment
  List<Comment> _flattenChildren(Comment comment, int depth) {
    final list = <Comment>[];

    for (final child in comment.children) {
      child.depth = depth;
      list.add(child);

      if (child.isExpanded) {
        list.addAll(_flattenChildren(child, depth + 1));
      }
    }

    return list;
  }
}
