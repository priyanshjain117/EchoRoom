import 'package:chat_app/widgets/pass_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key, required this.title});
  final String title;

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _roomNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  final firestore = FirebaseFirestore.instance;

  Future<void> _findRoom() async {
    try {
      final query = await firestore
          .collection('rooms')
          .where('name', isEqualTo: _roomNameController.text)
          .where('password', isEqualTo: _passwordController.text)
          .get();

      if (query.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1500),
              content: Text(
                "Make sure you entered valid details..",
              ),
            ),
          );
        }
        return;
      }

      final roomId = query.docs.first.id;

      await firestore.collection('rooms').doc(roomId).update({
        'members': FieldValue.arrayUnion([user!.uid])
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1500),
            content: Text('Room Joined successfully!'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _onSubmit() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    if (widget.title != "Create a Room") {
      _findRoom();
      return;
    }
    try {
      await firestore.collection('rooms').add({
            'name': _roomNameController.text,
            'password': _passwordController.text,
            'createdBy': user!.uid,
            'members': [user!.uid],
            'createdAt': Timestamp.now(),
            'lastUpdate': Timestamp.now(),
          } as Map<String, dynamic>);
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1500),
            content: Text('Room created successfully!'),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
        ),
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        height: double.maxFinite,
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _roomNameController,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Room Name',
                      hintText: widget.title == "Create a Room"
                          ? 'Enter your room name'
                          : 'Enter a room name to Join',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(169, 145, 196, 234),
                            width: 1.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color.fromARGB(219, 67, 196, 218),
                            width: 2.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    cursorColor: Colors.white70,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length <= 3) {
                        return 'Enter a valid room name of atleast 4 length';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PassField(
                    controller: _passwordController,
                    label: "Enter a password",
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return "Password must be at least 6 characters long.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton.icon(
                    icon: const Icon(
                      Icons.create,
                      color: Colors.white70,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black26,
                    ),
                    onPressed: _onSubmit,
                    label: Text(
                      widget.title == "Create a Room"
                          ? "Create Room"
                          : "Find Room",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
