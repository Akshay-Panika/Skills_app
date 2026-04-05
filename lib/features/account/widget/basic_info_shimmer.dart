import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skills_app/core/constant/app_color.dart';
import 'package:skills_app/core/constant/app_size.dart';

class BasicInfoShimmer extends StatelessWidget {
  const BasicInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          color: AppColor.primary,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: context.sHeight * 0.02),
          child:Shimmer.fromColors(
            baseColor: AppColor.surface,
            highlightColor: AppColor.surface.withOpacity(0.5),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: context.sHeight * 0.048,
                      backgroundColor: AppColor.surface,
                    ),
                    Container(
                      width: context.sHeight * 0.03,
                      height: context.sHeight * 0.03,
                      decoration: const BoxDecoration(
                        color: AppColor.surface,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.sHeight * 0.02),
                Container(
                  width: 140,
                  height: 14,
                  color: AppColor.surface,
                ),
                SizedBox(height: context.sHeight * 0.02),
              ],
            ),
          ),
        ),
        // Form Fields
        Shimmer.fromColors(
          baseColor: AppColor.surface,
          highlightColor: AppColor.surface.withOpacity(0.5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerLabel(context),
                _shimmerField(context),
                const SizedBox(height: 18),
                _shimmerLabel(context),
                _shimmerField(context),
                const SizedBox(height: 18),
                _shimmerLabel(context),
                _shimmerField(context),
                const SizedBox(height: 18),
                _shimmerLabel(context),
                // Gender buttons
                Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        height: context.sHeight * 0.05,
                        decoration: BoxDecoration(
                          color: AppColor.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                _shimmerLabel(context),
                _shimmerField(context, height: context.sHeight * 0.08),
              ],
            ),
          ),
        ),
        // Save Button
        Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: context.sHeight * 0.04,
          ),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _shimmerLabel(BuildContext context) {
    return Container(
      width: 120,
      height: 14,
      margin: const EdgeInsets.only(bottom: 8),
      color: AppColor.surface,
    );
  }

  Widget _shimmerField(BuildContext context, {double? height}) {
    return Container(
      height: height ?? 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}