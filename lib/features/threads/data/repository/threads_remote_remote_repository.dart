import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:thread_explorer/features/threads/data/models/comment.dart';

class ThreadsRemoteRepository {
  
  Future<Comment> getCommentsForStory({required int storyId}) async {
    try {
      final url = Uri.parse("http://hn.algolia.com/api/v1/items/$storyId");
      final response = await http.get(url);
      if(response.statusCode == 200) {
        final commentsJson = jsonDecode(response.body);
        return Comment.fromJson(commentsJson);
      } else {
        throw Exception("Api failure");
      }
    } catch (e) {
      throw Exception("Api failure");
    }
  }
}
