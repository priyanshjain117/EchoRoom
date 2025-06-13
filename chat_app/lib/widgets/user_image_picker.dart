import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _imagePicked;

  Future<void> _pickImage(ImageSource src) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: src,
      maxWidth: 320,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _imagePicked = File(pickedImage.path);
    });
    widget.onPickImage(_imagePicked!);
  }

  void _pickSource() {
    const styleButton = ButtonStyle(
      elevation: WidgetStatePropertyAll(12),
      iconSize: WidgetStatePropertyAll(50),
      foregroundColor: WidgetStatePropertyAll(Colors.amberAccent),
      iconColor: WidgetStatePropertyAll(Colors.white70),
    );
    final styleText = Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        );
    showBottomSheet(
      backgroundColor: Colors.blueGrey,
      context: context,
      builder: (context) => SizedBox(
        height: 125,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Icon(Icons.camera_alt),
              style: styleButton,
              onPressed: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
              label: Text(
                "Camera",
                style: styleText,
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.photo),
              style: styleButton,
              onPressed: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              label: Text(
                "Gallery",
                style: styleText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isImagePicked = _imagePicked != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: isImagePicked
                ? Image.file(
                    _imagePicked!,
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
            isImagePicked ? Icons.refresh : Icons.add_a_photo_outlined,
            color: Colors.white70,
          ),
          onPressed: _pickSource,
          label: Text(
            isImagePicked ? 'Retake' : "Add Photo",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white70,
                ),
          ),
        )
      ],
    );
  }
}
