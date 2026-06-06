import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const AppB());
}

// 1. Configure the Router
final GoRouter _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final uri = state.uri;
    
    // If it's our custom scheme, reconstruct the full internal route
    if (uri.scheme == 'myposapp') {
      final host = uri.host; // This will be 'order'
      final path = uri.path; // This will be '/123'
      
      // Combines them into '/order/123'
      return '/$host$path'; 
    }
    
    return null; 
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/order/:orderId', // This now matches /order/123 perfectly!
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? 'Unknown';
        return OrderDetailsScreen(orderId: orderId);
      },
    ),
  ],
);

class AppB extends StatelessWidget {
  const AppB({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Target App (App B)',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: _router, // Pass the configuration here
    );
  }
}

// 2. Placeholder Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App B Home')),
      body: const Center(child: Text('Waiting for deep link...')),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId')),
      body: Center(
        child: Text(
          'Viewing Details for Order ID: $orderId',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}