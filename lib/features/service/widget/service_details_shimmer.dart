// servicedetails/widget/service_details_shimmer.dart
import 'package:flutter/material.dart';
import '../../../core/constant/app_size.dart';

class ServiceDetailsShimmer extends StatefulWidget {
  const ServiceDetailsShimmer({super.key});

  @override
  State<ServiceDetailsShimmer> createState() => _ServiceDetailsShimmerState();
}

class _ServiceDetailsShimmerState extends State<ServiceDetailsShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    double width = double.infinity,
    double height = 16,
    double radius = 8,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
              ],
              transform: _SlidingGradientTransform(_animation.value),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = context.sWidth * 0.75;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // ── HERO IMAGE with price badge overlay ──────────────────────────
          SliverAppBar(
            expandedHeight: imageHeight,
            pinned: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) => const CircleAvatar(
                  backgroundColor: Color(0xFFE0E0E0),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) => const CircleAvatar(
                    backgroundColor: Color(0xFFE0E0E0),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Full image shimmer
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, _) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFE0E0E0),
                            Color(0xFFF5F5F5),
                            Color(0xFFE0E0E0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Price badge — bottom-right (like the ₹9999 teal badge)
                  Positioned(
                    bottom: 16,
                    right: 0,
                    child: _shimmerBox(
                      width: context.sWidth * 0.28,
                      height: context.sWidth * 0.1,
                      radius: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── TITLE (left) + LOCATION (right) ──────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title block — two lines like "Ethical Hacking / Learn with Chandu"
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(
                              width: context.sWidth * 0.55,
                              height: context.text16 + 2,
                            ),
                            SizedBox(height: context.sHeight * 0.006),
                            _shimmerBox(
                              width: context.sWidth * 0.42,
                              height: context.text14,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Location pin + distance
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _shimmerBox(
                            width: context.sWidth * 0.04,
                            height: context.sWidth * 0.04,
                            radius: 50,
                          ),
                          SizedBox(width: context.sWidth * 0.01),
                          _shimmerBox(
                            width: context.sWidth * 0.1,
                            height: context.text14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.sHeight * 0.022),

                  // ── AD BANNER ─────────────────────────────────────────────
                  _shimmerBox(
                    height: context.sWidth * 0.58,
                    radius: 14,
                  ),
                  SizedBox(height: context.sHeight * 0.022),

                  // ── SELLER CARD ───────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar
                        _shimmerBox(
                            width: 56, height: 56, radius: 50),
                        SizedBox(width: context.sWidth * 0.035),
                        // Name + Role
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerBox(
                                width: context.sWidth * 0.38,
                                height: context.text16,
                              ),
                              SizedBox(height: context.sHeight * 0.006),
                              _shimmerBox(
                                width: context.sWidth * 0.5,
                                height: context.text14,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: context.sWidth * 0.03),
                        // Rating badge — right side (star + 4.8 / 120 reviews)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _shimmerBox(
                              width: context.sWidth * 0.18,
                              height: context.sWidth * 0.07,
                              radius: 20,
                            ),
                            SizedBox(height: context.sHeight * 0.005),
                            _shimmerBox(
                              width: context.sWidth * 0.18,
                              height: context.text12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.sHeight * 0.022),

                  // ── "Report this skill" link ──────────────────────────────
                  Center(
                    child: _shimmerBox(
                      width: context.sWidth * 0.35,
                      height: context.text14,
                      radius: 6,
                    ),
                  ),
                  SizedBox(height: context.sHeight * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── BOTTOM BAR: "Chat With Mentor" + bookmark icon ─────────────────
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: context.sWidth * 0.04,
          right: context.sWidth * 0.04,
          bottom: context.sHeight * 0.03,
          top: context.sHeight * 0.01,
        ),
        child: Row(
          children: [
            // Wide CTA button
            Expanded(
              child: _shimmerBox(
                height: context.sWidth * 0.13,
                radius: 12,
              ),
            ),
            SizedBox(width: context.sWidth * 0.025),
            // Square bookmark button
            _shimmerBox(
              width: context.sWidth * 0.13,
              height: context.sWidth * 0.13,
              radius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

// ── GRADIENT SLIDING TRANSFORM ─────────────────────────────────────────────
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}