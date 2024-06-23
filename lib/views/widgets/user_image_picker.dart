import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
  File? _chooseImage;
  final SupabaseAuth _auth = SupabaseAuthImplementation();
  final storage = Supabase.instance.client.storage;

  Future<File> file(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, filename);
    return File(pathName);
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedImage == null) return;

    final userId = _auth.getCurrentUser()?.id;
    if (userId == null) return;

    // Upload image to Supabase storage
    final fileName = 'images/$userId/${pickedImage.path.split('/').last}';
    await storage.from('images').upload(
          fileName,
          File(pickedImage.path),
          fileOptions: const FileOptions(
            upsert: false,
            cacheControl: '3600',
          ),
        );

    setState(
      () {
        _chooseImage = File(pickedImage.path);
        widget.onSelectImage(_chooseImage!);
      },
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
              backgroundImage: _chooseImage != null
                  ? FileImage(_chooseImage!)
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
                  onTap: _pickImage,
                  child: _chooseImage != null
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
