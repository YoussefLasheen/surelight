import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surelight/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'IP Address',
              ),
              controller: TextEditingController(text: settings.ip),
              onChanged: (value) {
                ref.read(settingsProvider.notifier).set(
                      settings.copyWith(
                        ip: value,
                      ),
                    );
              },
            )
          ],
        ),
      ),
    );
  }
}
