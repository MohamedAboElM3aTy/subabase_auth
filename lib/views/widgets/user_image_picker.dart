import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subabase_auth/controller/supabase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onSelectImage,
    this.image,
  });

  final String? image;
  final void Function(File pickedImage) onSelectImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _chosenImage;
  final SupabaseAuth _auth = SupabaseAuthImplementation();
  final storage = Supabase.instance.client.storage;

  Future<void> _uploadImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    final userId = _auth.getCurrentUser()?.id;

    if (pickedImage == null || userId == null) return;

    final imagePath = 'images/$userId/${pickedImage.path.split('/').last}';

    await _uploadToStorage(path: imagePath, filePath: pickedImage.path);

    setState(() {
      _chosenImage = File(pickedImage.path);
      widget.onSelectImage(_chosenImage!);
    });
  }

  Future<void> _uploadToStorage({
    required String path,
    required String filePath,
  }) async {
    await storage.from('images').upload(
          path,
          File(filePath),
          fileOptions: const FileOptions(
            upsert: false,
            cacheControl: '3600',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey,
              backgroundImage: _chosenImage != null
                  ? FileImage(_chosenImage!)
                  : widget.image != null
                      ? CachedNetworkImageProvider(widget.image!)
                      : const AssetImage('assets/logo.jpeg') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: _uploadImage,
                  child: _chosenImage != null
                      ? const Icon(
                          Icons.edit,
                          size: 25,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.add,
                          size: 25,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
