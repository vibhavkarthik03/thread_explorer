import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/thread_bloc.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/thread_event.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/thread_state.dart';
import 'package:thread_explorer/features/threads/presentation/widgets/indent_lines.dart';
import 'package:thread_explorer/utils/date_time_utils.dart';

class ThreadScreen extends StatelessWidget {
  const ThreadScreen({super.key});

 static const int _storyId = 46368946;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThreadBloc()..add(LoadThread(storyId: _storyId)),
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thread Explorer", style: TextStyle(fontSize: 16),),
            const Text("(Story Id: $_storyId)", style: TextStyle(fontSize: 16),),
          ],
        ), backgroundColor: Colors.white,),
        body: BlocBuilder<ThreadBloc, ThreadState>(
          builder: (context, state) {
            if (state is ThreadLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ThreadLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                itemCount: state.visibleComments.length,
                itemBuilder: (context, i) {
                  final comment = state.visibleComments[i];

                  return GestureDetector(
                    onTap: () {
                      if (comment.children.isEmpty) return;
                      context.read<ThreadBloc>().add(ToggleExpand(comment));
                    },
                    child: IndentLines(
                      depth: comment.depth,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        comment.author,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text("•",
                                          style: TextStyle(fontSize: 12)),
                                      const SizedBox(width: 6),
                                      Text(
                                        comment.createdAt.timeAgoFromMs(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  HtmlWidget(
                                    comment.text,
                                    textStyle: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            if (comment.children.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  comment.isExpanded
                                      ? Icons.expand_more
                                      : Icons.chevron_right,
                                  size: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

