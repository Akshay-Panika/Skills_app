import 'package:flutter/material.dart';

// ─── Design Tokens ─────────────────────────────────────────────
class _C {
  static const primary     = Color(0xFF0D6E6E);
  static const primaryDark = Color(0xFF094F4F);
  static const accent      = Color(0xFFFFB347);
  static const surface     = Color(0xFFF4F7F7);
  static const card        = Color(0xFFFFFFFF);
  static const textDark    = Color(0xFF0D1F1F);
  static const textMid     = Color(0xFF4A6565);
  static const textLight   = Color(0xFF8AABAB);
  static const chipBg      = Color(0xFFE6F2F2);
  static const danger      = Color(0xFFE05757);
}

// ─── Model ─────────────────────────────────────────────────────
class NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final String type;
  final bool isUnread;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isUnread = false,
  });
}

// ─── Dummy Data ────────────────────────────────────────────────
final List<NotificationItem> todayNotifications = [
  NotificationItem(
    title: "New Lecture Added",
    subtitle: "Flutter UI Design - Module 5 is now live",
    time: "10:30 AM",
    type: "course",
    isUnread: true,
  ),
  NotificationItem(
    title: "Assignment Reminder",
    subtitle: "Submit your UI assignment before 6 PM",
    time: "9:00 AM",
    type: "assignment",
    isUnread: true,
  ),
];

final List<NotificationItem> yesterdayNotifications = [
  NotificationItem(
    title: "Live Class Starting",
    subtitle: "Join your React class at 7 PM",
    time: "Yesterday",
    type: "live",
  ),
  NotificationItem(
    title: "Course Completed 🎉",
    subtitle: "You completed Python Basics",
    time: "Yesterday",
    type: "general",
  ),
];

// ─── Screen ────────────────────────────────────────────────────
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.surface,
      body: Column(
        children: [
          _buildHeader(context),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const _SectionTitle(title: "Today"),
                ...todayNotifications.map((e) => _NotificationCard(item: e)),

                const SizedBox(height: 20),

                const _SectionTitle(title: "Yesterday"),
                ...yesterdayNotifications.map((e) => _NotificationCard(item: e)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.primaryDark, _C.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Title ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _C.textLight,
        ),
      ),
    );
  }
}

// ─── Notification Card ─────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isUnread ? _C.chipBg : _C.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _C.primary.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Icon ───
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _getColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(), color: _getColor(), size: 22),
          ),

          const SizedBox(width: 12),

          // ─── Content ───
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _C.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: _C.textMid,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _C.textLight,
                  ),
                ),
              ],
            ),
          ),

          // ─── Unread Dot ───
          if (item.isUnread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: _C.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (item.type) {
      case "course":
        return Icons.play_circle_fill;
      case "assignment":
        return Icons.assignment;
      case "live":
        return Icons.videocam;
      default:
        return Icons.notifications;
    }
  }

  Color _getColor() {
    switch (item.type) {
      case "course":
        return _C.primary;
      case "assignment":
        return _C.accent;
      case "live":
        return _C.danger;
      default:
        return _C.textLight;
    }
  }
}