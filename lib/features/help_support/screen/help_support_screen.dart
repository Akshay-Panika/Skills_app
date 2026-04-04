import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.black87,
                      size: 36,
                    ),
                  ),
                  // Logo
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child:  FaIcon(
                          FontAwesomeIcons.chalkboardTeacher,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Skill',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Support',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Avatar row + greeting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overlapping avatars
                  SizedBox(
                    height: 44,
                    width: 110,
                    child: Stack(
                      children: [
                        _buildAvatar(0, 'https://i.pravatar.cc/150?img=1'),
                        _buildAvatar(30, 'https://i.pravatar.cc/150?img=2'),
                        _buildAvatar(60, 'https://i.pravatar.cc/150?img=3'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Hello, Users',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'How can we help?',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Cards area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.05,
                  padding: const EdgeInsets.all(20),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: const [
                    _SupportCard(
                      icon: Icons.chat_bubble_rounded,
                      iconColor: Color(0xFF4CAF9E),
                      iconBgColor: Color(0xFFE0F5F1),
                      title: 'Chat\nwith us',
                    ),
                    _SupportCard(
                      icon: Icons.phone_in_talk_rounded,
                      iconColor: Color(0xFF4CAF50),
                      iconBgColor: Color(0xFFE8F5E9),
                      title: 'Message us on\nWhatsApp (24/7)',
                      useWhatsApp: true,
                    ),
                    _SupportCard(
                      icon: Icons.email_rounded,
                      iconColor: Color(0xFFFFC107),
                      iconBgColor: Color(0xFFFFF8E1),
                      title: 'Send us\nan Email',
                    ),
                    _SupportCard(
                      icon: Icons.call_rounded,
                      iconColor: Color(0xFFFF7043),
                      iconBgColor: Color(0xFFFBE9E7),
                      title: 'Call us\n(Mon-Fri, 9am-5pm)',
                    ),
                    _SupportCard(
                      icon: Icons.play_circle_fill_rounded,
                      iconColor: Color(0xFF2196F3),
                      iconBgColor: Color(0xFFE3F2FD),
                      title: 'Watch\nTutorials',
                    ),
                    _SupportCard(
                      icon: Icons.article_rounded,
                      iconColor: Color(0xFF90A4AE),
                      iconBgColor: Color(0xFFECEFF1),
                      title: 'Read\nArticles',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double left, String url) {
    return Positioned(
      left: left,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF1A1A2E), width: 2.5),
          color: Colors.grey.shade400,
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final bool useWhatsApp;

  const _SupportCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.useWhatsApp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: useWhatsApp
                        ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg',
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.phone_in_talk_rounded,
                          color: iconColor,
                          size: 26,
                        ),
                      ),
                    )
                        : Icon(icon, color: iconColor, size: 26),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFBDBDBD),
                    size: 20,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}