import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../controller/http_controller.dart';

class TerminalWidget extends StatelessWidget {
  const TerminalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
        border: Border(
          left: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 16),
                const SizedBox(width: 8),
                const Text('Terminal', style: TextStyle(fontSize: 13)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => controller.showTerminal.value = false,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                final response = controller.currentResponse.value;
                if (response == null) {
                  return Center(
                    child: Text(
                      'No terminal output yet',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTerminalText(
                        'Request: ${controller.httpMethod.value} ${controller.url.value}',
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      _buildTerminalText(
                        'Status: ${response.statusText}    Size: ${response.sizeText}    Time: ${response.timeText}',
                      ),
                      const SizedBox(height: 16),
                      _buildTerminalText('Response', color: Colors.white),
                      const SizedBox(height: 8),
                      _buildTerminalText(
                        const JsonEncoder.withIndent(
                          '  ',
                        ).convert(response.body),
                        color: Colors.orange[300],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalText(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Courier',
        color: color ?? Colors.grey[400],
      ),
    );
  }
}
