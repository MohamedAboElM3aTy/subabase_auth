import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subabase_auth/views/widgets/user_image_picker.dart';

class SupabaseStoragePage extends StatefulWidget {
  const SupabaseStoragePage({
    super.key,
    required this.userName,
  });
  final String userName;

  @override
  State<SupabaseStoragePage> createState() => _SupabaseStoragePageState();
}

class _SupabaseStoragePageState extends State<SupabaseStoragePage> {
  File? _selectedImage;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserImagePicker(
              onSelectImage: (image) => setState(() => _selectedImage = image),
            ),
          ],
        ),
      ),
    );
  }
}
