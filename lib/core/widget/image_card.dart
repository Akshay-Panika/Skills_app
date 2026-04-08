import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;

  const ImageCard({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 14,
  });

  // 1. Cloudinary Image Optimization Logic
  String getOptimizedUrl(String url) {
    if (url.contains("cloudinary.com")) {
      return url.replaceAll("/upload/", "/upload/f_auto,q_auto,w_500/");
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: getOptimizedUrl(imageUrl),
        height: height,
        width: width,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
        memCacheHeight: 300,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }
}