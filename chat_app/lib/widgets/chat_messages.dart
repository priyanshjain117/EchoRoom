import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.doc});
  final QueryDocumentSnapshot doc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc(doc.id)
          .collection('messages')
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
        
        final loadedMessages=snapshot.data!.docs;

        if (loadedMessages.isEmpty) {
           return Center(
          child: Text("No message yet..."),
        );
        }
        return ListView.builder(itemCount: loadedMessages.length,itemBuilder: (context, index) {
          
        },);
      },
    );
  }
}
