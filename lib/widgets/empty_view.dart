import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final String? animationAssets;

  const EmptyView({
    super.key,
    required this.message,
    required this.animationAssets,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //jangan pakaikrung kurawal dia tidak bisa
            //kalau if() {} else {} ini jadai error kalau dalam kalang []
            if (animationAssets != null)
              Lottie.asset(animationAssets!, width: 150)
            else
              const Icon(Icons.inbox, color: Colors.grey, size: 45),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
