import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  final String? animationAsset;
  final double size;
  const LoadingView({super.key, this.animationAsset, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: animationAsset != null
          ? Lottie.asset(animationAsset!, width: size, height: size)
          : const CircularProgressIndicator(),
    );
  }
}
