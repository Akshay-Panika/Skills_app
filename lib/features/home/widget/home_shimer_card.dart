import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerCard extends StatelessWidget {
  const HomeShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFFE0E0E0);
    const highlightColor = Color(0xFFF5F5F5);

    return Scaffold(
      // 1. Shimmer AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xFF006D5B), // Image ka teal color
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Shimmer.fromColors(
          baseColor: Colors.white24,
          highlightColor: Colors.white54,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 80, height: 12, color: Colors.white),
                  const SizedBox(height: 4),
                  Container(width: 120, height: 10, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Shimmer.fromColors(
            baseColor: Colors.white24,
            highlightColor: Colors.white54,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],
        // 2. Search Bar Shimmer (Bottom of AppBar)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Shimmer.fromColors(
            baseColor: Colors.white24,
            highlightColor: Colors.white54,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title: Grow Your Skills
                Container(width: 150, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 20),

                // Grid Categories (2 Rows)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 10,
                  itemBuilder: (_, __) => Column(
                    children: [
                      Container(width: 55, height: 55, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                      const SizedBox(height: 8),
                      Container(width: 40, height: 8, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Invite Banner
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                ),

                const SizedBox(height: 25),

                // Section Title: Recent View Services
                Container(width: 180, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 15),

                // Horizontal Service Cards
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 220,
                            height: 160,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          ),
                          const SizedBox(height: 12),
                          Container(width: 160, height: 15, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: 100, height: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}