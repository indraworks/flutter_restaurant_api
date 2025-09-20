import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final String tag;
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const HeroImage({
    super.key,
    required this.tag,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      ),
    );
  }
}
