import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skills_app/core/constant/app_size.dart';
import 'package:skills_app/core/widget/app_card.dart';

// chat_list_shimmer.dart

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: context.sWidth * 0.03,
        bottom: context.sHeight * 0.1,
      ),
      itemCount: 5,
      itemBuilder: (_, __) => const _ShimmerChatCard(),
    );
  }
}

class _ShimmerChatCard extends StatelessWidget {
  const _ShimmerChatCard();

  @override
  Widget build(BuildContext context) {
    final w = context.sWidth;
    final h = context.sHeight;

    return AppCard(
      margin: EdgeInsets.only(
        bottom: w * 0.025,
        left: w * 0.03,
        right: w * 0.03,
      ),
      padding: EdgeInsets.all(w * 0.03),
      color: Colors.white,
      child:Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: Image + Text ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service image (square, same as CachedNetworkImage size)
                Container(
                  width: h * 0.1,
                  height: h * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.03),
                  ),
                ),
                SizedBox(width: w * 0.03),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      _ShimBox(w: w * 0.42, h: 13),
                      SizedBox(height: w * 0.015),
                      // Bio
                      _ShimBox(w: w * 0.32, h: 11),
                      SizedBox(height: w * 0.025),
                      // Message line 1
                      _ShimBox(w: double.infinity, h: 11),
                      SizedBox(height: w * 0.012),
                      // Message line 2
                      _ShimBox(w: w * 0.55, h: 11),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: w * 0.03),

            // ── Bottom Row: Badge + Date ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Service name badge pill
                _ShimBox(w: w * 0.35, h: 22, radius: 30),
                // Date
                _ShimBox(w: w * 0.22, h: 11),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable shimmer box
class _ShimBox extends StatelessWidget {
  final double w, h, radius;
  const _ShimBox({
    required this.w,
    required this.h,
    this.radius = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}