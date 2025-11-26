import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:get_x_master/get_x_master.dart';

import '../../models/http_response_model.dart';

class ResponseStatusBar extends StatelessWidget {
  final HttpResponseModel? response;
  final bool isDark;
  final VoidCallback onShowCodeSnippet;

  const ResponseStatusBar({
    super.key,
    required this.response,
    required this.isDark,
    required this.onShowCodeSnippet,
  });

  @override
  Widget build(BuildContext context) {
    if (response == null) {
      return _buildEmptyState(context);
    }

    return _buildStatusBar(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.grey[400]),
          const SizedBox(width: 8),
          Text(
            'Send a request to see response',
            style: context.textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    final statusColor = response!.statusCode >= 200 && response!.statusCode < 300
        ? Colors.green
        : response!.statusCode >= 400
            ? Colors.red
            : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 500;

          if (isNarrow) {
            return _buildCompactLayout(context, statusColor);
          }
          return _buildWideLayout(context, statusColor);
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, Color statusColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatusChip(statusColor),
          const SizedBox(width: 8),
          _buildSizeChip(),
          const SizedBox(width: 8),
          _buildTimeChip(),
          const SizedBox(width: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildCompactLayout(BuildContext context, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMiniChip(
                'Status: ${response!.statusText}',
                statusColor,
              ),
              const SizedBox(width: 6),
              _buildMiniChip('Size: ${response!.sizeText}', Colors.blue),
              const SizedBox(width: 6),
              _buildMiniChip('Time: ${response!.timeText}', Colors.orange),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildMiniChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip(Color statusColor) {
    return Chip(
      avatar: Icon(Icons.check_circle, size: 16, color: statusColor),
      label: Text(
        'Status: ${response!.statusText}',
        style: TextStyle(
          fontSize: 12,
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: statusColor.withValues(alpha: 0.1),
      side: BorderSide(color: statusColor.withValues(alpha: 0.3)),
    );
  }

  Widget _buildSizeChip() {
    return Chip(
      avatar: const Icon(Icons.data_usage, size: 16, color: Colors.blue),
      label: Text(
        'Size: ${response!.sizeText}',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
      side: BorderSide(color: Colors.blue.withValues(alpha: 0.3)),
    );
  }

  Widget _buildTimeChip() {
    return Chip(
      avatar: const Icon(Icons.timer, size: 16, color: Colors.orange),
      label: Text(
        'Time: ${response!.timeText}',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
      side: BorderSide(color: Colors.orange.withValues(alpha: 0.3)),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.code, size: 18),
          onPressed: onShowCodeSnippet,
          tooltip: 'Code Snippet',
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          padding: EdgeInsets.zero,
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: const JsonEncoder.withIndent('  ').convert(response!.body),
              ),
            );
            Get.snackbar(
              'Copied',
              'Response copied to clipboard',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
            );
          },
          tooltip: 'Copy Response',
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
