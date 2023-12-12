import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/models/user_model.dart';
import 'package:flutter_danthocode_instagram_clone/providers/user_model_provider.dart';
import 'package:flutter_danthocode_instagram_clone/resources/firestore_method.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/comment_card.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/loader.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({
    super.key,
    required this.snap,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModelProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: InstagramColor.mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  snap: snapshot.data!.docs[index],
                );
              });
        },
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                user.photoUrl,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Comments as ${user.username}',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethod().postComment(
                  user.username,
                  _commentController.text,
                  user.uid,
                  widget.snap['postId'],
                  user.photoUrl,
                );
                setState(() {
                  _commentController.text = '';
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: InstagramColor.blueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
