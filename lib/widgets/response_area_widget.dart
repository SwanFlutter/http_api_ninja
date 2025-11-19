// ignore_for_file: dead_code

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_view/flutter_code_view.dart';
import 'package:get_x_master/get_x_master.dart';

import '../I18n/messages.dart';
import '../controller/http_controller.dart';
import '../models/http_response_model.dart';

class ResponseAreaWidget extends StatelessWidget {
  const ResponseAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          // Status Bar with Chips
          Obx(() {
            final response = controller.currentResponse.value;
            if (response == null) {
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
                      style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                    ),
                  ],
                ),
              );
            }

            final statusColor =
                response.statusCode >= 200 && response.statusCode < 300
                ? Colors.green
                : response.statusCode >= 400
                ? Colors.red
                : Colors.orange;

            return Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Status Chip
                    Chip(
                      avatar: Icon(
                        Icons.check_circle,
                        size: 16,
                        color: statusColor,
                      ),
                      label: Text(
                        'Status: ${response.statusText}',
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: statusColor.withValues(alpha: 0.1),
                      side: BorderSide(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Size Chip
                    Chip(
                      avatar: const Icon(
                        Icons.data_usage,
                        size: 16,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Size: ${response.sizeText}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      side: BorderSide(
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Time Chip
                    Chip(
                      avatar: const Icon(
                        Icons.timer,
                        size: 16,
                        color: Colors.orange,
                      ),
                      label: Text(
                        'Time: ${response.timeText}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Colors.orange.withValues(alpha: 0.1),
                      side: BorderSide(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Action Buttons
                    IconButton(
                      icon: const Icon(Icons.code, size: 18),
                      onPressed: () =>
                          _showCodeSnippetDialog(context, controller),
                      tooltip: 'Code Snippet',
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: const JsonEncoder.withIndent(
                              '  ',
                            ).convert(response.body),
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
                    ),
                  ],
                ),
              ),
            );
          }),

          // Response Tabs
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252526) : Colors.grey[50],
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      [
                        Messages.response,
                        Messages.headers,
                        Messages.cookies,
                        Messages.results,
                        Messages.docs,
                        'code_snippet',
                      ].map((tab) {
                        final isSelected =
                            controller.selectedResponseTab.value == tab;
                        final count = tab == Messages.headers
                            ? controller
                                      .currentResponse
                                      .value
                                      ?.headers
                                      .length ??
                                  0
                            : tab == Messages.results
                            ? controller.testsList.length
                            : null;
                        final isCodeTab = tab == 'code_snippet';

                        return InkWell(
                          onTap: () =>
                              controller.selectedResponseTab.value = tab,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isCodeTab)
                                  Icon(
                                    Icons.code,
                                    size: 18,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[400],
                                  )
                                else
                                  Text(
                                    tab.tr,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[400],
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                if (count != null && count > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '$count',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),

          // Response Content
          Expanded(
            child: Container(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Obx(() {
                final response = controller.currentResponse.value;
                final selectedTab = controller.selectedResponseTab.value;

                if (response == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Send a request to see the response',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Response Tab
                if (selectedTab == Messages.response) {
                  return _buildResponseTab(response, isDark, controller);
                }

                // Headers Tab
                if (selectedTab == Messages.headers) {
                  return _buildHeadersTab(response, isDark, controller);
                }

                // Cookies Tab
                if (selectedTab == Messages.cookies) {
                  return _buildCookiesTab(isDark);
                }

                // Results Tab
                if (selectedTab == Messages.results) {
                  return _buildResultsTab(controller, isDark);
                }

                // Docs Tab
                if (selectedTab == Messages.docs) {
                  return _buildDocsTab(controller, response, isDark);
                }

                // Code Snippet Tab
                if (selectedTab == 'code_snippet') {
                  return _buildCodeSnippetTab(controller, isDark);
                }

                return const SizedBox.shrink();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseTab(
    HttpResponseModel response,
    bool isDark,
    HttpController controller,
  ) {
    return Column(
      children: [
        // Format Button
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.format_align_left, size: 16),
                label: const Text('Format'),
              ),
            ],
          ),
        ),
        // Response Body
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: FlutterCodeView(
                  source: const JsonEncoder.withIndent(
                    '  ',
                  ).convert(response.body),
                  language: Languages.json,
                  themeType: isDark ? ThemeType.dracula : ThemeType.github,
                  showLineNumbers: true,
                  fontSize: 13,
                  padding: const EdgeInsets.all(12),
                  borderRadius: BorderRadius.circular(8),
                  borderColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
              // Copy Button
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: const JsonEncoder.withIndent(
                            '  ',
                          ).convert(response.body),
                        ),
                      );
                      controller.showNotification(
                        'Response copied to clipboard',
                        'success',
                      );
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
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeadersTab(
    HttpResponseModel response,
    bool isDark,
    HttpController controller,
  ) {
    if (response.headers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No headers',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Convert headers to formatted string for copy
    final headersString = response.headers.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');

    return Column(
      children: [
        // Header with title and copy button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Response Headers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: headersString));
                  controller.showNotification(
                    'Headers copied to clipboard',
                    'success',
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy,
                        size: 16,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Copy',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D30) : Colors.grey[100],
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Header',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Text(
                  'Value',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table Body
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: response.headers.length,
            itemBuilder: (context, index) {
              final entry = response.headers.entries.elementAt(index);
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SelectableText(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontFamily: 'Courier',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: SelectableText(
                        entry.value,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.purple[300]
                              : Colors.purple[700],
                          fontFamily: 'Courier',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCookiesTab(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cookie_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No cookies', style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildResultsTab(HttpController controller, bool isDark) {
    if (controller.testsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No tests defined', style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.testsList.length,
      itemBuilder: (context, index) {
        final test = controller.testsList[index];
        final passed = true;

        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: passed
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            border: Border.all(color: passed ? Colors.green : Colors.red),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                passed ? Icons.check_circle : Icons.cancel,
                color: passed ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${test['condition']} ${test['operator']} ${test['value']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      passed ? 'Test passed' : 'Test failed',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDocsTab(
    HttpController controller,
    HttpResponseModel response,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isNarrow ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'API Documentation',
                style: TextStyle(
                  fontSize: isNarrow ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: isNarrow ? 16 : 24),

              // Info Cards - Responsive Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildInfoCard(
                    'Endpoint',
                    controller.url.value,
                    Icons.link,
                    Colors.blue,
                    isDark,
                    isNarrow,
                  ),
                  _buildInfoCard(
                    'Method',
                    controller.httpMethod.value,
                    Icons.http,
                    Colors.green,
                    isDark,
                    isNarrow,
                  ),
                  _buildInfoCard(
                    'Status',
                    '${response.statusCode}',
                    Icons.check_circle,
                    Colors.orange,
                    isDark,
                    isNarrow,
                  ),
                  _buildInfoCard(
                    'Time',
                    response.timeText,
                    Icons.timer,
                    Colors.purple,
                    isDark,
                    isNarrow,
                  ),
                  _buildInfoCard(
                    'Size',
                    response.sizeText,
                    Icons.data_usage,
                    Colors.red,
                    isDark,
                    isNarrow,
                  ),
                ],
              ),

              SizedBox(height: isNarrow ? 20 : 24),

              // Response Schema Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Response Schema',
                    style: TextStyle(
                      fontSize: isNarrow ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: _generateSchema(response.body)),
                      );
                      controller.showNotification(
                        'Schema copied to clipboard',
                        'success',
                      );
                    },
                    tooltip: 'Copy Schema',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Schema with Syntax Highlighting
              FlutterCodeView(
                source: _generateSchema(response.body),
                language: Languages.json,
                themeType: isDark ? ThemeType.dracula : ThemeType.github,
                showLineNumbers: true,
                fontSize: isNarrow ? 11 : 13,
                padding: EdgeInsets.all(isNarrow ? 8 : 12),
                borderRadius: BorderRadius.circular(8),
                borderColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
    bool isNarrow,
  ) {
    return Container(
      constraints: BoxConstraints(minWidth: isNarrow ? 150 : 180),
      padding: EdgeInsets.all(isNarrow ? 10 : 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isNarrow ? 11 : 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isNarrow ? 12 : 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _generateSchema(dynamic data) {
    if (data is Map) {
      final schema = <String, dynamic>{};
      data.forEach((key, value) {
        schema[key] = _getType(value);
      });
      return const JsonEncoder.withIndent('  ').convert(schema);
    } else if (data is List && data.isNotEmpty) {
      return const JsonEncoder.withIndent(
        '  ',
      ).convert({'type': 'array', 'items': _getType(data[0])});
    }
    return const JsonEncoder.withIndent('  ').convert({'type': _getType(data)});
  }

  dynamic _getType(dynamic value) {
    if (value is String) return 'string';
    if (value is int) return 'integer';
    if (value is double) return 'number';
    if (value is bool) return 'boolean';
    if (value is List) {
      if (value.isEmpty) return 'array';
      return {'type': 'array', 'items': _getType(value[0])};
    }
    if (value is Map) {
      final schema = <String, dynamic>{};
      value.forEach((key, val) {
        schema[key] = _getType(val);
      });
      return schema;
    }
    return 'unknown';
  }

  Widget _buildCodeSnippetTab(HttpController controller, bool isDark) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Top Bar with buttons
          Container(
            padding: const EdgeInsets.all(12),
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
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.code, size: 16),
                  label: const Text('Code Snippet'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Generate Types'),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252526) : Colors.grey[50],
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: const TabBar(
              tabs: [
                Tab(text: 'Code'),
                Tab(text: 'Http'),
                Tab(text: 'Copy'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              children: [
                _buildCodeTabContent(controller, isDark),
                _buildHttpTabContent(controller, isDark),
                _buildCopyTabContent(controller, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeTabContent(HttpController controller, bool isDark) {
    final languages = [
      'C',
      'Clojure',
      'C#',
      'cURL',
      'Dart',
      'Go',
      'HTTP',
      'Java',
      'JavaScript',
      'Kotlin',
      'Node.js',
      'Objective-C',
      'OCaml',
      'PHP',
      'Powershell',
      'Python',
      'R',
      'Ruby',
      'Shell',
      'Swift',
    ];

    return Row(
      children: [
        // Language Selector
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
            border: Border(
              right: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.language, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return Obx(() {
                      final isSelected =
                          controller.selectedCodeLanguage.value == lang;
                      return InkWell(
                        onTap: () =>
                            controller.selectedCodeLanguage.value = lang,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                      ? const Color(0xFF37373D)
                                      : Colors.grey[200])
                                : Colors.transparent,
                          ),
                          child: Text(
                            lang,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? Theme.of(Get.context!).primaryColor
                                  : (isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[800]),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Code Display
        Expanded(
          child: Column(
            children: [
              // Toolbar
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        final code = _generateCodeForLanguage(
                          controller,
                          controller.selectedCodeLanguage.value,
                        );
                        Clipboard.setData(ClipboardData(text: code));
                        Get.snackbar('Copied', 'Code copied to clipboard');
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy'),
                    ),
                  ],
                ),
              ),

              // Code
              Expanded(
                child: Obx(() {
                  final code = _generateCodeForLanguage(
                    controller,
                    controller.selectedCodeLanguage.value,
                  );
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      code,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHttpTabContent(HttpController controller, bool isDark) {
    final httpRequest =
        '''
${controller.httpMethod.value} ${controller.url.value} HTTP/1.1
${controller.headers.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

${controller.body.value}
''';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: httpRequest));
                  Get.snackbar('Copied', 'HTTP request copied to clipboard');
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy'),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              httpRequest,
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyTabContent(HttpController controller, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCopyOption('Copy URL', controller.url.value, Icons.link, isDark),
        _buildCopyOption(
          'Copy Headers',
          controller.headers.entries
              .map((e) => '${e.key}: ${e.value}')
              .join('\n'),
          Icons.http,
          isDark,
        ),
        _buildCopyOption(
          'Copy Body',
          controller.body.value,
          Icons.description,
          isDark,
        ),
        if (controller.currentResponse.value != null)
          _buildCopyOption(
            'Copy Response',
            const JsonEncoder.withIndent(
              '  ',
            ).convert(controller.currentResponse.value!.body),
            Icons.code,
            isDark,
          ),
      ],
    );
  }

  Widget _buildCopyOption(
    String title,
    String content,
    IconData icon,
    bool isDark,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          content.isEmpty
              ? 'Empty'
              : '${content.substring(0, content.length > 50 ? 50 : content.length)}...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: content));
            Get.snackbar('Copied', '$title copied to clipboard');
          },
        ),
      ),
    );
  }

  String _generateCodeForLanguage(HttpController controller, String language) {
    switch (language) {
      case 'Dart':
        return _generateDartCode(controller);
      case 'JavaScript':
      case 'Node.js':
        return _generateJavaScriptCode(controller);
      case 'Python':
        return _generatePythonCode(controller);
      case 'cURL':
        return _generateCurlCode(controller);
      case 'Java':
        return _generateJavaCode(controller);
      case 'Go':
        return _generateGoCode(controller);
      case 'PHP':
        return _generatePhpCode(controller);
      case 'Ruby':
        return _generateRubyCode(controller);
      case 'Swift':
        return _generateSwiftCode(controller);
      case 'C#':
        return _generateCSharpCode(controller);
      default:
        return '// Code generation for $language coming soon...';
    }
  }

  String _generateJavaCode(HttpController controller) {
    return '''
import java.net.http.*;
import java.net.URI;

public class ApiRequest {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("${controller.url.value}"))
            .${controller.httpMethod.value}()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println(response.body());
    }
}
''';
  }

  String _generateGoCode(HttpController controller) {
    return '''
package main

import (
    "fmt"
    "net/http"
    "io/ioutil"
)

func main() {
    url := "${controller.url.value}"
    
    req, _ := http.NewRequest("${controller.httpMethod.value}", url, nil)
    
    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()
    
    body, _ := ioutil.ReadAll(resp.Body)
    fmt.Println(string(body))
}
''';
  }

  String _generatePhpCode(HttpController controller) {
    return '''
<?php

\$url = '${controller.url.value}';

\$ch = curl_init(\$url);
curl_setopt(\$ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt(\$ch, CURLOPT_CUSTOMREQUEST, '${controller.httpMethod.value}');

\$response = curl_exec(\$ch);
curl_close(\$ch);

echo \$response;
?>
''';
  }

  String _generateRubyCode(HttpController controller) {
    return '''
require 'net/http'
require 'json'

url = URI('${controller.url.value}')

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::${controller.httpMethod.value.capitalize}.new(url)

response = http.request(request)
puts response.body
''';
  }

  String _generateSwiftCode(HttpController controller) {
    return '''
import Foundation

let url = URL(string: "${controller.url.value}")!
var request = URLRequest(url: url)
request.httpMethod = "${controller.httpMethod.value}"

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let data = data {
        let str = String(data: data, encoding: .utf8)
        print(str ?? "")
    }
}

task.resume()
''';
  }

  String _generateCSharpCode(HttpController controller) {
    return '''
using System;
using System.Net.Http;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        using var client = new HttpClient();
        
        var response = await client.${controller.httpMethod.value == 'GET' ? 'GetAsync' : 'PostAsync'}(
            "${controller.url.value}"
        );
        
        var content = await response.Content.ReadAsStringAsync();
        Console.WriteLine(content);
    }
}
''';
  }

  void _showCodeSnippetDialog(BuildContext context, HttpController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Code Snippet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Dart'),
                          Tab(text: 'JavaScript'),
                          Tab(text: 'Python'),
                          Tab(text: 'cURL'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildCodeTab(_generateDartCode(controller)),
                            _buildCodeTab(_generateJavaScriptCode(controller)),
                            _buildCodeTab(_generatePythonCode(controller)),
                            _buildCodeTab(_generateCurlCode(controller)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeTab(String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                code,
                style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Get.snackbar('Copied', 'Code copied to clipboard');
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy Code'),
          ),
        ],
      ),
    );
  }

  String _generateDartCode(HttpController controller) {
    return '''
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> makeRequest() async {
  final url = Uri.parse('${controller.url.value}');
  
  final response = await http.${controller.httpMethod.value.toLowerCase()}(
    url,
    headers: ${controller.headers.isEmpty ? '{}' : controller.headers.toString()},
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  }
}
''';
  }

  String _generateJavaScriptCode(HttpController controller) {
    return '''
fetch('${controller.url.value}', {
  method: '${controller.httpMethod.value}',
  headers: ${jsonEncode(controller.headers)},
})
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
''';
  }

  String _generatePythonCode(HttpController controller) {
    return '''
import requests

url = '${controller.url.value}'
headers = ${controller.headers.isEmpty ? '{}' : controller.headers.toString()}

response = requests.${controller.httpMethod.value.toLowerCase()}(url, headers=headers)

if response.status_code == 200:
    data = response.json()
    print(data)
''';
  }

  String _generateCurlCode(HttpController controller) {
    final headers = controller.headers.entries
        .map((e) => "-H '${e.key}: ${e.value}'")
        .join(' ');
    return '''
curl -X ${controller.httpMethod.value} \\
  '${controller.url.value}' \\
  $headers
''';
  }
}
