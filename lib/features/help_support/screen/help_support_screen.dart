import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
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
                      AppCard(
                        color: AppColor.primary,
                        child:  FaIcon(
                          FontAwesomeIcons.chalkboardTeacher,
                          size: context.sHeight*0.02,
                          color: Colors.white,
                        ),
                      ),

                       Text(
                        'Skill',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: context.text16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                       Text(
                        'Daan',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: context.text14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

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
                   Text(
                    'Hello, Users',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: context.text14,
                    ),
                  ),
                  const SizedBox(height: 4),
                   Text(
                    'How can we help?',
                    style: TextStyle(
                      color: AppColor.title,
                      fontSize: context.text20,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Cards area
            Expanded(
              child: AppCard(
                color: AppColor.surface,
                width: double.infinity,
                margin: EdgeInsets.zero,
                borderRadius: 40,
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
                  AppCard(
                    width: context.sHeight*0.05,
                    height:context.sHeight*0.05,
                    color: iconBgColor,
                    margin: EdgeInsets.zero,
                    child: useWhatsApp
                        ? Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg',
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.phone_in_talk_rounded,
                            color: iconColor,
                            size: context.sHeight*0.03,
                          ),
                        )
                        : Icon(icon, color: iconColor, size: context.sHeight*0.03,),
                  ),
                   Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade300,
                    size: context.sHeight*0.03,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: AppColor.subtitle,
                  fontSize: context.text14,
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