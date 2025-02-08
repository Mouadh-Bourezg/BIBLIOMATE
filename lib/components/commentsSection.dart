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
  final CommentsService commentsService =
      CommentsService(Supabase.instance.client);
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
    final fetchedComments =
        await commentsService.getCommentsForDocument(widget.documentId);
    for (var comment in fetchedComments) {
      final userId = comment['user_id'];
      if (!userNames.containsKey(userId)) {
        final userInfo = await userService.getUserInformation(userId);
        userNames[userId] =
            "${userInfo['first_name']} ${userInfo['last_name']}";
      }
    }
    setState(() {
      comments = fetchedComments;
    });
  }

  Future<void> addComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return; // Prevent empty comments
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to comment')),
      );
      return;
    }
    await commentsService.addComment(widget.documentId, currentUserId, content);
    commentController.clear();
    await loadComments();
  }

  Future<void> _editComment(Map<String, dynamic> comment) async {
    final TextEditingController editController =
        TextEditingController(text: comment['content']);
    final commentId = comment['id'];
    final result = await showDialog(
      context: context,
      builder: (ctx) => _buildModernDialog(
        title: 'Edit Comment',
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText: 'Enter new comment text',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx, editController.text.trim());
            },
            child: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final success = await commentsService.updateComment(commentId, result);
      if (success) {
        await loadComments(); // Reload all comments
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update comment')),
          );
        }
      }
    }
  }

  Future<void> _deleteComment(Map<String, dynamic> comment) async {
    final commentId = comment['id'];
    final bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => _buildModernDialog(
        title: 'Delete Comment',
        content: const Text(
          'Are you sure you want to delete this comment?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final success = await commentsService.deleteComment(commentId);
      if (success) {
        await loadComments(); // Reload all comments
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete comment')),
          );
        }
      }
    }
  }

  Widget _buildModernDialog({
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: actions,
      backgroundColor: Colors.white,
      elevation: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final displayedComments =
        showAllComments ? comments : comments.take(3).toList();

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01), // 1% of screen height
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02), // 2% of screen width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comments Header
          Row(
            children: [
              Icon(Icons.comment,
                  color: Colors.blue,
                  size: screenWidth * 0.05), // 5% of screen width
              SizedBox(width: screenWidth * 0.02), // 2% of screen width
              Text(
                'Comments (${comments.length})',
                style: TextStyle(
                  fontSize: screenWidth * 0.04, // 4% of screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01), // 1% of screen height
          // Comments List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedComments.length,
            itemBuilder: (context, index) {
              final comment = displayedComments[index];
              final userId = comment['user_id'];
              final userName = userNames[userId] ?? "Unknown User";
              final dateOnly = comment['time'].split('T')[0];
              final currentUserId =
                  Supabase.instance.client.auth.currentUser?.id;
              final isAuthor = (currentUserId == userId);

              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.005), // 0.5% of screen height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      screenWidth * 0.03), // 3% of screen width
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: screenWidth * 0.05, // 5% of screen width
                    backgroundColor: Colors.blue[300],
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.03), // 3% of screen width
                    ),
                  ),
                  title: Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: screenWidth * 0.035, // 3.5% of screen width
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.005), // 0.5% of screen height
                    child: Text(
                      comment['content'],
                      style: TextStyle(
                          fontSize: screenWidth * 0.03), // 3% of screen width
                    ),
                  ),
                  trailing: isAuthor
                      ? PopupMenuButton(
                          icon: Icon(Icons.more_vert,
                              size: screenWidth * 0.05), // 5% of screen width
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editComment(comment);
                            } else if (value == 'delete') {
                              _deleteComment(comment);
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        )
                      : Text(
                          dateOnly,
                          style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.grey), // 3% of screen width
                        ),
                ),
              );
            },
          ),
          // "See More" or "See Less" Button
          if (comments.length > 3)
            TextButton(
              onPressed: () {
                setState(() {
                  showAllComments = !showAllComments;
                });
              },
              child: Text(
                showAllComments ? "See Less" : "See More",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: screenWidth * 0.035, // 3.5% of screen width
                ),
              ),
            ),
          Divider(thickness: screenHeight * 0.002), // 0.2% of screen height
          // Add New Comment Section
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Add a comment...",
                    fillColor: Colors.grey[100],
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02, // 2% of screen width
                      vertical: screenHeight * 0.01, // 1% of screen height
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.05), // 5% of screen width
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02), // 2% of screen width
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(
                      screenWidth * 0.05), // 5% of screen width
                ),
                child: IconButton(
                  icon: Icon(Icons.send,
                      color: Colors.white,
                      size: screenWidth * 0.05), // 5% of screen width
                  onPressed: addComment,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
