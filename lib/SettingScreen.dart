import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotionalEmails = false;
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionTitle("Account"),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: "Personal Information",
              subtitle: "Update your profile details",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: "Change Password",
              subtitle: "Update your password",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.security_outlined,
              title: "Privacy & Security",
              subtitle: "Manage your privacy settings",
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Notifications Section
            _buildSectionTitle("Notifications"),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: "All Notifications",
              subtitle: "Enable or disable all notifications",
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  if (!value) {
                    _emailNotifications = false;
                    _pushNotifications = false;
                    _orderUpdates = false;
                    _promotionalEmails = false;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.email_outlined,
              title: "Email Notifications",
              subtitle: "Receive updates via email",
              value: _emailNotifications,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.push_pin_outlined,
              title: "Push Notifications",
              subtitle: "Receive push notifications",
              value: _pushNotifications,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.shopping_bag_outlined,
              title: "Order Updates",
              subtitle: "Get notified about order status",
              value: _orderUpdates,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _orderUpdates = value;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.local_offer_outlined,
              title: "Promotional Emails",
              subtitle: "Receive special offers and deals",
              value: _promotionalEmails,
              onChanged: _notificationsEnabled
                  ? (value) {
                      setState(() {
                        _promotionalEmails = value;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 32),

            // Appearance Section
            _buildSectionTitle("Appearance"),
            const SizedBox(height: 12),
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              subtitle: "Switch to dark theme",
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.language_outlined,
              title: "Language",
              subtitle: _language,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                _showLanguageDialog();
              },
            ),
            const SizedBox(height: 32),

            // Other Section
            _buildSectionTitle("Other"),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: "Help & Support",
              subtitle: "Get help and support",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: "Terms & Conditions",
              subtitle: "Read our terms",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "Read our privacy policy",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: "About",
              subtitle: "Version 1.0.0",
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Delete Account
            OutlinedButton(
              onPressed: () {
                _showDeleteAccountDialog();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Delete Account",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: trailing ??
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: onChanged != null ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6C63FF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Select Language",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption("English"),
            _buildLanguageOption("Spanish"),
            _buildLanguageOption("French"),
            _buildLanguageOption("German"),
            _buildLanguageOption("Vietnamese"),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: _language,
      activeColor: const Color(0xFF6C63FF),
      onChanged: (value) {
        setState(() {
          _language = value!;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete Account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}