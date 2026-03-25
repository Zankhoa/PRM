import 'package:flutter/material.dart';
import '../../../data/service/shop_owner_service.dart';
import '../../../data/models/shop_owner_dto.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<ShopOwnerDTO>(
        future: ShopOwnerService.getProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(radius: 40, child: Text(user.name[0])),
                const SizedBox(height: 10),
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(user.email),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(user: user),
                      ),
                    );
                  },
                  child: const Text("Edit Profile"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}