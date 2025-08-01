import 'package:chat_app/widgets/app_bar_menu.dart';
import 'package:chat_app/widgets/custom_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatListScreen> {
  final fcm = FirebaseMessaging.instance;

  Future<void> _setUpFirebaseMessage() async {
    await fcm.requestPermission();
    final fcmToken = await fcm.getToken();
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    print(fcmToken);

    if (user != null && fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcmToken': fcmToken,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setUpFirebaseMessage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            "EchoRoom",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
          ),
          actions: [
            Builder(
              builder: (context) => AppBarMenu(),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.primary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomSearchBar(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
