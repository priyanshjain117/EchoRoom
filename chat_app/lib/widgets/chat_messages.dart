import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.doc});
  final QueryDocumentSnapshot doc;

  final loggedInUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(doc.id)
          .collection('messages')
          .orderBy(
            'sentAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong..."),
          );
        }

        final loadedMessages = snapshot.data!.docs;

        if (loadedMessages.isEmpty) {
          return Center(
            child: Text(
              "No messages yet...",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          );
        }
        return ListView.builder(
          itemCount: loadedMessages.length,
          reverse: true,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index].data();
            final nextMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['senderId'];
            final currentMessageUsername = chatMessage['username'];
            final currentMessageImageUrl = chatMessage['imageUrl'];
            final currentMessageText = chatMessage['text'];

            final nextMessageUserId =
                nextMessage != null ? nextMessage['senderId'] : null;

            final isSame = nextMessageUserId == currentMessageUserId;

            if (isSame) {
              return MessageBubble.next(
                message: currentMessageText,
                isMe: currentMessageUserId == loggedInUser!.uid,
              );
            }

            return MessageBubble.first(
                userImage: currentMessageImageUrl,
                username: currentMessageUsername,
                message: currentMessageText,
                isMe: currentMessageUserId == loggedInUser!.uid);
          },
        );
      },
    );
  }
}
