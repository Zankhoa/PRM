import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_owner_screen/presentation/widgets/CustomBottomNav/custom_bottom_shopwoner.dart';
import 'package:shop_owner_screen/data/models/shop_profile_dto.dart';
import 'package:shop_owner_screen/data/service/shop_owner_service.dart';
import 'package:shop_owner_screen/presentation/screens/ShopOwner/edit_profile.dart';
import 'package:shop_owner_screen/presentation/screens/User/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ShopOwnerService _service = ShopOwnerService();
  ShopProfileDto? _profile;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.fetchProfile(widget.userId);
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavShopOwner(
        userId: widget.userId,
        currentTab: kTabProfile,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Không thể tải hồ sơ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchProfile,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A11CB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final p = _profile!;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── HEADER ──
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Hồ sơ cá nhân',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Edit button
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, color: Colors.white),
                          onPressed: () async {
                            final updated = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                  userId: widget.userId,
                                  profile: p,
                                ),
                              ),
                            );
                            if (updated == true) _fetchProfile();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout_rounded, color: Colors.white),
                          onPressed: _logout,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -48,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFFE8E4FF),
                    backgroundImage: (p.avatarUser != null && p.avatarUser!.isNotEmpty)
                        ? NetworkImage(p.avatarUser!)
                        : null,
                    child: (p.avatarUser == null || p.avatarUser!.isEmpty)
                        ? const Icon(Icons.person, size: 48, color: Color(0xFF6A11CB))
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 64),

          // ── NAME & USERNAME ──
          Text(
            p.fullName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '@${p.username}',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 24),

          // ── INFO CARDS ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildInfoCard([
                  _buildInfoRow(Icons.email_rounded, 'Email', p.email ?? 'Chưa cập nhật'),
                  const Divider(height: 1),
                  _buildInfoRow(Icons.phone_rounded, 'Số điện thoại', p.phone ?? 'Chưa cập nhật'),
                  const Divider(height: 1),
                  _buildInfoRow(Icons.location_on_rounded, 'Địa chỉ', p.address ?? 'Chưa cập nhật'),
                  const Divider(height: 1),
                  _buildInfoRow(
                    Icons.calendar_today_rounded,
                    'Ngày tham gia',
                    p.createdAt != null
                        ? '${p.createdAt!.day}/${p.createdAt!.month}/${p.createdAt!.year}'
                        : 'Không rõ',
                  ),
                ]),

                const SizedBox(height: 24),

                // ── EDIT BUTTON ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            userId: widget.userId,
                            profile: p,
                          ),
                        ),
                      );
                      if (updated == true) _fetchProfile();
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Chỉnh sửa hồ sơ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A11CB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFC62828),
                      side: const BorderSide(color: Color(0xFFC62828)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6A11CB).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6A11CB)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
