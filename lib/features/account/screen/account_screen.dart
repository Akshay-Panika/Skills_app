import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// PROFILE CARD
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    /// AVATAR
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.blueAccent.withOpacity(.15),
                      child: const Icon(Icons.person,
                          size: 32, color: Colors.blueAccent),
                    ),
              
                    const SizedBox(width: 14),
              
                    /// USER INFO
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Akshay Panika",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("+91 98765 43210",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
              Positioned(
                  right: 0,top: 0,
                  child:   IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: Colors.black,),
              ))
            ],
          ),

          const SizedBox(height: 18),

          /// STATS
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(title: "Ads", value: "12"),
                _Divider(),
                _StatItem(title: "Favorites", value: "8"),
                _Divider(),
                _StatItem(title: "Views", value: "230"),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// MENU LIST
          const _MenuTile(icon: Icons.campaign_outlined, title: "My Ads"),
          const _MenuTile(icon: Icons.favorite_border, title: "Favorites"),
          const _MenuTile(icon: Icons.payment_outlined, title: "Payments"),
          const _MenuTile(icon: Icons.settings_outlined, title: "Settings"),
          const _MenuTile(icon: Icons.help_outline, title: "Help & Support"),
          const _MenuTile(icon: Icons.login_outlined, title: "Sign Out"),

        ],
      ),
    );
  }
}

/// ================= STAT ITEM =================
class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

/// DIVIDER
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.grey.shade300,
    );
  }
}

/// ================= MENU TILE =================
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}