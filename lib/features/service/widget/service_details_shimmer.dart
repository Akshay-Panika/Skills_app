import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          /// ── IMAGE SHIMMER (SliverAppBar) ─────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) => CircleAvatar(
                  backgroundColor: const Color(0xFFE0E0E0),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
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
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ── TITLE & PRICE ────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _shimmerBox(height: 20, width: 200),
                      ),
                      const SizedBox(width: 16),
                      _shimmerBox(width: 60, height: 20),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// ── LOCATION ─────────────────────────────────────
                  Row(
                    children: [
                      _shimmerBox(width: 16, height: 16, radius: 50),
                      const SizedBox(width: 6),
                      _shimmerBox(width: 140, height: 14),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// ── DESCRIPTION TITLE ────────────────────────────
                  _shimmerBox(width: 100, height: 18),
                  const SizedBox(height: 10),

                  /// ── DESCRIPTION LINES ────────────────────────────
                  _shimmerBox(height: 13),
                  const SizedBox(height: 6),
                  _shimmerBox(height: 13),
                  const SizedBox(height: 6),
                  _shimmerBox(height: 13),
                  const SizedBox(height: 6),
                  _shimmerBox(width: 220, height: 13),

                  /// ── AD BANNER ────────────────────────────────────
                  Container(
                    height: 250,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: _shimmerBox(height: 250, radius: 14),
                  ),

                  /// ── SELLER CARD ───────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Avatar
                        _shimmerBox(
                            width: 64, height: 64, radius: 50),

                        const SizedBox(width: 12),

                        /// Name + Bio
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              _shimmerBox(width: 120, height: 16),
                              const SizedBox(height: 8),
                              _shimmerBox(height: 12),
                              const SizedBox(height: 4),
                              _shimmerBox(width: 160, height: 12),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Rating (top right)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _shimmerBox(width: 40, height: 14),
                            const SizedBox(height: 4),
                            _shimmerBox(width: 70, height: 12),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),

      /// ── BOTTOM BUTTON SHIMMER ──────────────────────────────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: _shimmerBox(height: 50, radius: 10),
              ),
              const SizedBox(width: 10),
              _shimmerBox(width: 54, height: 50, radius: 10),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── GRADIENT TRANSFORM ─────────────────────────────────────────────
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}