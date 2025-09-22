import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_submit/providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text("Daily Reminder at 11:00 AM"),
                value: provider.isScheduled,
                onChanged: (value) {
                  provider.toggleScheduled(value);
                  final snackBar = SnackBar(
                    content: Text(
                      value
                          ? "Daily reminder enabled"
                          : "Daily reminder disabled",
                    ),
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
