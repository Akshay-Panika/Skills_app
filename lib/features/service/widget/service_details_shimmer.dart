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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // IMAGE SHIMMER
          SliverAppBar(
            expandedHeight: context.sWidth * 0.7,
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
                  // TITLE & PRICE + LOCATION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(child: _shimmerBox(height: context.text16, width: 200)),

                      // Price & Location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _shimmerBox(width: 60, height: context.text16),
                          SizedBox(height: context.sHeight * 0.005),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _shimmerBox(
                                  width: context.sWidth * 0.04,
                                  height: context.sWidth * 0.04,
                                  radius: 50),
                              SizedBox(width: context.sWidth * 0.01),
                              _shimmerBox(width: context.sWidth * 0.2, height: context.text14),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.sHeight * 0.02),

                  // DESCRIPTION
                  _shimmerBox(width: context.sWidth * 0.4, height: context.text16),
                  SizedBox(height: context.sHeight * 0.01),
                  _shimmerBox(height: context.text14),
                  SizedBox(height: context.sHeight * 0.005),
                  _shimmerBox(height: context.text14),
                  SizedBox(height: context.sHeight * 0.005),
                  _shimmerBox(width: context.sWidth * 0.5, height: context.text14),
                  SizedBox(height: context.sHeight * 0.02),

                  // AD BANNER
                  Container(
                    height: context.sWidth * 0.6,
                    margin: EdgeInsets.zero,
                    child: _shimmerBox(height: context.sWidth * 0.6, radius: 14),
                  ),
                  SizedBox(height: context.sHeight * 0.02),

                  // SELLER CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: 64, height: 64, radius: 50),
                        SizedBox(width: context.sWidth * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _shimmerBox(width: context.sWidth * 0.4, height: context.text16),
                              SizedBox(height: context.sHeight * 0.005),
                              _shimmerBox(height: context.text14),
                              SizedBox(height: context.sHeight * 0.002),
                              // _shimmerBox(width: context.sWidth * 0.5, height: context.text14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.sHeight * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),

      // BOTTOM BUTTON SHIMMER
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: context.sWidth * 0.04,
            right: context.sWidth * 0.04,
            bottom: context.sHeight * 0.03),
        child: SizedBox(
          height: context.sWidth * 0.12,
          child: Row(
            children: [
              Expanded(child: _shimmerBox(height: context.sWidth * 0.12, radius: 10)),
              SizedBox(width: context.sWidth * 0.02),
              _shimmerBox(width: context.sWidth * 0.12, height: context.sWidth * 0.12, radius: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// GRADIENT TRANSFORM
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}