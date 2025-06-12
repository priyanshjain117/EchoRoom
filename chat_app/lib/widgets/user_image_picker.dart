import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? imagePicked;

  Future<void> _onAddImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      imagePicked = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: imagePicked != null
                ? Image.file(
                    imagePicked!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Transform.translate(
                      offset: const Offset(0, 12), // move down by 8 pixels
                      child: Transform.scale(
                        scale: 1.2, // zoom in
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        TextButton.icon(
          icon: Icon(
            Icons.add_a_photo_outlined,
            color: Colors.white70,
          ),
          onPressed: _onAddImage,
          label: Text(
            "Add Photo",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white70,
                ),
          ),
        )
      ],
    );
  }
}
