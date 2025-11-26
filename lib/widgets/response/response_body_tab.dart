import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_view/flutter_code_view.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';
import '../../models/http_response_model.dart';

class ResponseBodyTab extends StatelessWidget {
  final HttpResponseModel response;
  final bool isDark;
  final HttpController controller;

  const ResponseBodyTab({
    super.key,
    required this.response,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(context),
        Expanded(child: _buildCodeView(context)),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.format_align_left, size: 16),
            label: Text('Format', style: context.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeView(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FlutterCodeView(
            source: const JsonEncoder.withIndent('  ').convert(response.body),
            language: Languages.json,
            themeType: isDark ? ThemeType.dracula : ThemeType.github,
            showLineNumbers: true,
            fontSize: 13,
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(8),
            borderColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
        _buildCopyButton(context),
      ],
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Clipboard.setData(
              ClipboardData(
                text: const JsonEncoder.withIndent('  ').convert(response.body),
              ),
            );
            controller.showNotification('Response copied to clipboard', 'success');
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey[800]!.withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.copy,
                  size: 16,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
                const SizedBox(width: 4),
                Text(
                  'Copy',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
