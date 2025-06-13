import 'package:chat_app/widgets/app_bar_menu.dart';
import 'package:chat_app/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
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
