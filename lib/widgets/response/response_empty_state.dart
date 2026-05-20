import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

class ResponseEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const ResponseEmptyState({
    super.key,
    this.icon = Icons.send_outlined,
    this.message = 'Send a request to see the response',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ResponseCookiesTab extends StatelessWidget {
  final bool isDark;

  const ResponseCookiesTab({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return const ResponseEmptyState(
      icon: Icons.cookie_outlined,
      message: 'No cookies',
    );
  }
}
