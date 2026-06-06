import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AppA());
}

class AppA extends StatelessWidget {
  const AppA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sender App (App A)',
      home: const SenderHomeScreen(),
    );
  }
}

class SenderHomeScreen extends StatefulWidget {
  const SenderHomeScreen({super.key});

  @override
  State<SenderHomeScreen> createState() => _SenderHomeScreenState();
}

class _SenderHomeScreenState extends State<SenderHomeScreen> {
  final TextEditingController _controller = TextEditingController(text: "7890");

  // The Core Navigation Function
Future<void> _openAppB(String orderId) async {
  final Uri url = Uri.parse('myposapp://order/$orderId');

  try {
    // On Android 11+, canLaunchUrl might still return false if permissions are weird,
    // so we can also rely on a try-catch blocks for launching directly.
    await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication, // Best mode for app-to-app
    );
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch App B: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App A (Sender)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Order ID to pass',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openAppB(_controller.text.trim()),
              child: const Text('Open App B Order Screen'),
            ),
          ],
        ),
      ),
    );
  }
}