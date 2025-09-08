import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback?
  onRetry; //kalau optional jangan lagi diconstruct tulis required

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40),
            SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            if (onRetry != null)
              ElevatedButton(onPressed: onRetry, child: Text('Retry')),
          ],
        ),
      ),
    );
  }
}
