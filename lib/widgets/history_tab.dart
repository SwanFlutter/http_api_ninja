import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../controller/http_controller.dart';
import '../models/history_model.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Search and filter
        _buildSearchBar(context, controller, isDark),

        // Filter chips
        _buildFilterChips(context, controller, isDark),

        // History list
        Expanded(
          child: Obx(() {
            final filteredHistory = controller.filteredHistory;

            if (filteredHistory.isEmpty) {
              return _buildEmptyState(context, controller);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                final item = filteredHistory[index];
                return _buildHistoryItem(context, controller, item, isDark);
              },
            );
          }),
        ),

        // Clear history button
        _buildFooter(context, controller, isDark),
      ],
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search history...',
          hintStyle: context.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
          prefixIcon: const Icon(Icons.search, size: 18),
          suffixIcon: Obx(
            () => controller.historySearchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => controller.historySearchQuery.value = '',
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF3C3C3C) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        style: context.textTheme.bodySmall,
        onChanged: (value) => controller.historySearchQuery.value = value,
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    final methods = ['All', 'GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: methods.length,
        itemBuilder: (context, index) {
          final method = methods[index];
          return Obx(() {
            final isSelected = controller.historyFilterMethod.value == method;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  method,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isSelected ? Colors.white : null,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) =>
                    controller.historyFilterMethod.value = method,
                backgroundColor: isDark
                    ? const Color(0xFF3C3C3C)
                    : Colors.grey[200],
                selectedColor: _getMethodColor(method),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    HttpController controller,
    HistoryModel item,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => controller.loadFromHistory(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Method badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getMethodColor(item.method).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    item.method,
                    style: TextStyle(
                      fontSize: 10,
                      color: _getMethodColor(item.method),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Status badge
                if (item.statusCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: item.isSuccess
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '${item.statusCode}',
                      style: TextStyle(
                        fontSize: 10,
                        color: item.isSuccess ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const Spacer(),

                // Time ago
                Text(
                  item.formattedTime,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),

                // Delete button
                IconButton(
                  icon: const Icon(Icons.close, size: 14),
                  onPressed: () => controller.deleteHistoryItem(item.id),
                  visualDensity: VisualDensity.compact,
                  color: Colors.grey[400],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // URL
            Text(
              item.url,
              style: context.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Request name if available
            if (item.requestName != null) ...[
              const SizedBox(height: 4),
              Text(
                item.requestName!,
                style: context.textTheme.labelSmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],

            // Response info
            if (item.responseTime != null || item.responseSize != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (item.responseTime != null) ...[
                    Icon(Icons.timer, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      '${item.responseTime}ms',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (item.responseSize != null) ...[
                    Icon(Icons.data_usage, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      _formatSize(item.responseSize!),
                      style: context.textTheme.labelSmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, HttpController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            controller.historySearchQuery.value.isNotEmpty ||
                    controller.historyFilterMethod.value != 'All'
                ? 'No matching requests'
                : 'No request history',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a request to see it here',
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    return Obx(() {
      if (controller.history.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              '${controller.history.length} requests',
              style: context.textTheme.labelSmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_sweep, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    'Clear',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'all', child: Text('Clear All')),
                const PopupMenuItem(
                  value: 'day',
                  child: Text('Clear older than 1 day'),
                ),
                const PopupMenuItem(
                  value: 'week',
                  child: Text('Clear older than 1 week'),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'all':
                    _showClearHistoryDialog(context, controller);
                    break;
                  case 'day':
                    controller.clearHistoryOlderThan(const Duration(days: 1));
                    break;
                  case 'week':
                    controller.clearHistoryOlderThan(const Duration(days: 7));
                    break;
                }
              },
            ),
          ],
        ),
      );
    });
  }

  void _showClearHistoryDialog(
    BuildContext context,
    HttpController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear History', style: context.textTheme.titleSmall),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.clearHistory();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      case 'All':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
