import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key, required this.doc});
  final QueryDocumentSnapshot doc;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _messageController.text.trim().isEmpty) return;
    final messageData = {
      'text': _messageController.text.trim(),
      'senderId': currentUser.uid,
      'sentAt': Timestamp.now(),
    };
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.doc.id)
        .collection('messages')
        .add(messageData);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 25,
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromARGB(255, 111, 159, 184),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 3,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.659),
                      ),
                      enabledBorder: InputBorder.none),
                  cursorColor: Colors.white70,
                  keyboardType: TextInputType.text,
                ),
              ),
              IconButton(
                onPressed: _submitMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
