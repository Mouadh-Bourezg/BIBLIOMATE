import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/commentsServices.dart';
import '../services/userServices.dart';

class CommentsSection extends StatefulWidget {
  final int documentId;

  const CommentsSection({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final CommentsService commentsService = CommentsService(Supabase.instance.client);
  final UserService userService = UserService(Supabase.instance.client);
  List<Map<String, dynamic>> comments = [];
  Map<String, String> userNames = {};
  bool showAllComments = false;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    final fetchedComments = await commentsService.getCommentsForDocument(widget.documentId);

    // Fetch user names for each unique user_id
    for (var comment in fetchedComments) {
      final userId = comment['user_id'];
      if (!userNames.containsKey(userId)) {
        final userInfo = await userService.getUserInformation(userId);
        userNames[userId] = "${userInfo['first_name']} ${userInfo['last_name']}";
      }
    }

    setState(() {
      comments = fetchedComments;
    });
  }

  Future<void> addComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return; // Prevent empty comments

    await commentsService.addComment(widget.documentId, (Supabase.instance.client.auth.currentUser?.id)!, content);
    commentController.clear();
    await loadComments(); // Refresh comments after adding
  }

  @override
  Widget build(BuildContext context) {
    final displayedComments = showAllComments ? comments : comments.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comments List
        ...displayedComments.map((comment) {
          final userId = comment['user_id'];
          final userName = userNames[userId] ?? "Unknown User";

          return ListTile(
            leading: CircleAvatar(child: Text(userName[0])),
            title: Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(comment['content']),
            trailing: Text(comment['time'].split('T')[0]), // Show only date
          );
        }).toList(),

        // "See More" button
        if (comments.length > 3 && !showAllComments)
          TextButton(
            onPressed: () => setState(() => showAllComments = true),
            child: Text("See More"),
          ),

        // "See Less" button
        if (showAllComments)
          TextButton(
            onPressed: () => setState(() => showAllComments = false),
            child: Text("See Less"),
          ),

        // Add New Comment Section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: addComment,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
