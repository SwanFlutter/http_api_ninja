import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../controller/theme_controller.dart';

class WelcomeScreenWidget extends StatelessWidget {
  const WelcomeScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1E1E),
                  const Color(0xFF2D2D30),
                  const Color(0xFF1E1E1E),
                ]
              : [
                  const Color(0xFFF5F5F5),
                  const Color(0xFFE8E8E8),
                  const Color(0xFFF5F5F5),
                ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Obx(
                  () => Image.asset(
                    themeController.isDark
                        ? 'assets/logo_dark.png'
                        : 'assets/logo_dark.png',
                    width: 180,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.blue.withValues(alpha: 0.2)
                              : Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: Icon(
                          Icons.http,
                          size: 90,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // App Title
                Text(
                  'HTTP API Ninja',
                  style: context.textTheme.displaySmall?.copyWith(
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'A powerful HTTP client for developers',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 50),

                // Quick actions
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildQuickActionCard(
                      context,
                      icon: Icons.add_circle_outline,
                      title: 'New Request',
                      subtitle: 'Create HTTP request',
                      color: Colors.blue,
                      isDark: isDark,
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: Icons.folder_outlined,
                      title: 'New Collection',
                      subtitle: 'Organize requests',
                      color: Colors.green,
                      isDark: isDark,
                    ),
                    _buildQuickActionCard(
                      context,
                      icon: Icons.history,
                      title: 'Recent Activity',
                      subtitle: 'View history',
                      color: Colors.orange,
                      isDark: isDark,
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Tips
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Tip: Select a request from the sidebar or create a new one to get started',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.blue[200] : Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D30) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
