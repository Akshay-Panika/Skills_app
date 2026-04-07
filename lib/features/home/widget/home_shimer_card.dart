import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skills_app/core/constant/app_color.dart';

import '../../../core/constant/app_size.dart';

class HomeShimmerCard extends StatelessWidget {
  const HomeShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.sWidth;
    final height = context.sHeight;

    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Shimmer.fromColors(
          baseColor: Colors.white24,
          highlightColor: Colors.white70,
          child: Row(
            children: [
              Container(
                width: width * 0.1, // responsive
                height: width * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: width * 0.025),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: width * 0.2, height: height * 0.015, color: Colors.white),
                  SizedBox(height: height * 0.005),
                  Container(width: width * 0.3, height: height * 0.012, color: Colors.white),
                ],
              ),
            ],
          ),
        ),

        actions: [
          Shimmer.fromColors(
            baseColor: Colors.white24,
            highlightColor: Colors.white70,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Icon(Icons.bookmark, color: Colors.white),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.white24,
            highlightColor: Colors.white70,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.08),
          child: Shimmer.fromColors(
            baseColor: Colors.white24,
            highlightColor: Colors.white70,
            child: Padding(
              padding: EdgeInsets.fromLTRB(width * 0.04, 0, width * 0.04, height * 0.02),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: height * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.025),
                  Container(
                    width: width * 0.12,
                    height: height * 0.04,
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

      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView(
          padding: EdgeInsets.all(width * 0.04),
          children: [
            Container(width: width * 0.3, height: height * 0.025, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
            SizedBox(height: height * 0.02),

            /// Categories
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: width * 0.03,
                crossAxisSpacing: width * 0.02,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (_, __) => Column(
                children: [
                  Container(
                    width: width * 0.15,
                    height: width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: height * 0.009),
                  Container(width: width * 0.08, height: height * 0.012, color: Colors.white),
                ],
              ),
            ),

            // SizedBox(height: height * 0.01),

            /// Banner
            Container(
              height: height * 0.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            SizedBox(height: height * 0.03),

            /// Section title
            Container(
              width: width * 0.4,
              height: height * 0.02,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            SizedBox(height: height * 0.02),

            /// Horizontal cards
            SizedBox(
              height: height * 0.28,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (_, __) => Padding(
                  padding: EdgeInsets.only(right: width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.6,
                        height: height * 0.18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Container(width: width * 0.35, height: height * 0.018, color: Colors.white),
                      SizedBox(height: height * 0.005),
                      Container(width: width * 0.25, height: height * 0.015, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}