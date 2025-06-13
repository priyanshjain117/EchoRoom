import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/helper/credentials.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:chat_app/widgets/pass_field.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isAuthenticating = false;
  String _enteredEmail = '';
  String? _username = '';
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _selectedImage;

  Future<String?> _uploadImage(File file, String fileName) async {
    const String uploadPreset = 'flutter_unsigned';

    final Uri uploadUrl = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final Map<String, dynamic> jsonRes = json.decode(resStr);
      final imageUrl = jsonRes['secure_url'];
      final publicId = jsonRes['public_id'];

      print('Uploaded successfully! URL: $imageUrl');
      return imageUrl;
    } else {
      print('Upload failed with status: ${response.statusCode}');
      return null;
    }
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!_isLogin && _selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please upload an image"),
        ),
      );
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        //  log in process
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _passwordController.text,
        );
      } else {
        // sign up process
        print(_passwordController.text);

        final userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _passwordController.text,
        );
        // After the user signs up:
        final imageUrl =
            await _uploadImage(_selectedImage!, userCredential.user!.uid);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _username,
          'email': _enteredEmail,
          'imageUrl': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Authentication Failed!",
          ),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            center: Alignment.topRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Center(
                child: Opacity(
                  opacity: 0.37,
                  child: Image.asset(
                    './assets/images/chat.png',
                    width: 200,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(13),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 32.0, top: 10),
                      margin: const EdgeInsets.all(
                        20,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isLogin)
                                  const Icon(
                                    Icons.person,
                                    size: 120,
                                    weight: 999,
                                    color: Color.fromARGB(189, 235, 199, 199),
                                  ),
                                if (!_isLogin)
                                  UserImagePicker(
                                    onPickImage: (pickedImage) {
                                      _selectedImage = pickedImage;
                                    },
                                  ),
                                SizedBox(height: _isLogin ? 12 : 0),
                                TextFormField(
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white54,
                                      ),
                                    ),
                                    errorStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  cursorColor: Colors.white70,
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                                    if (value == null || value.trim().isEmpty) {
                                      return "Please enter an email address";
                                    } else if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _enteredEmail = newValue!;
                                  },
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                if (!_isLogin)
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      errorStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    enableSuggestions: false,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          value.trim().length < 4) {
                                        return "Enter username of atleast 4 character long";
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      _username = newValue;
                                    },
                                  ),
                                SizedBox(
                                  height: 2,
                                ),
                                PassField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return "Password must be at least 6 characters long.";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                if (!_isLogin)
                                  PassField(
                                    controller: _confirmPasswordController,
                                    label: 'Re-enter Password',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please re-enter your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                SizedBox(
                                  height: 11,
                                ),
                                if (_isAuthenticating)
                                  const CircularProgressIndicator(
                                    color: Colors.blueGrey,
                                  ),
                                if (!_isAuthenticating)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _submit,
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          _isLogin ? "Sign in" : "Sign Up",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Flexible(
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLogin = !_isLogin;
                                            });
                                          },
                                          child: Text(
                                            _isLogin
                                                ? "Create an account"
                                                : "Already have an account",
                                            softWrap: true,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    // fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
