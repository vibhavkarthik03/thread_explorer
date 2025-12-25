import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thread_explorer/features/threads/data/models/comment.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/threads_bloc.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/threads_event.dart';
import 'package:thread_explorer/features/threads/presentation/bloc/threads_state.dart';
import 'package:thread_explorer/features/threads/presentation/widgets/indent_lines.dart';
import 'package:thread_explorer/utils/date_time_utils.dart';

class ThreadScreen extends StatelessWidget {

  const ThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThreadBloc()..add(LoadThread()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Thread Explorer")),
        body: BlocBuilder<ThreadBloc, ThreadState>(
          builder: (context, state) {
            if (state is ThreadLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ThreadLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: state.visibleComments.length,
                  itemBuilder: (context, i) {
                    final c = state.visibleComments[i];

                    return InkWell(
                      onTap: () {
                        context.read<ThreadBloc>().add(ToggleExpand(c));
                      },
                      child: IndentLines(
                        depth: c.depth,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: (c.depth * 16).toDouble(),
                            top: 8,
                            bottom: 8,
                            right: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(c.author,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 2,),
                                        Text(".", style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 2,),
                                        Text(c.createdAt.timeAgoFromMs(), style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    HtmlWidget(c.text),
                                  ],
                                ),
                              ),
                              if (c.children.isNotEmpty)
                                Icon(
                                  c.isExpanded
                                      ? Icons.expand_more
                                      : Icons.chevron_right,
                                  size: 18,
                                ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
