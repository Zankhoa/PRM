import 'package:flutter/material.dart';
import '../../../data/models/shop_owner_dto.dart';
import '../../../data/service/shop_owner_service.dart';

class EditProfileScreen extends StatefulWidget {
  final ShopOwnerDTO user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController),
            TextField(controller: emailController),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await ShopOwnerService.updateProfile({
                  "name": nameController.text,
                  "email": emailController.text,
                });

                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}