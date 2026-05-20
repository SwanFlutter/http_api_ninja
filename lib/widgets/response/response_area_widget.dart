import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../I18n/messages.dart';
import '../../controller/http_controller.dart';
import 'response_body_tab.dart';
import 'response_code_snippet_tab.dart';
import 'response_docs_tab.dart';
import 'response_empty_state.dart';
import 'response_headers_tab.dart';
import 'response_results_tab.dart';
import 'response_status_bar.dart';
import 'response_tabs.dart';

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
          // Status Bar
          Obx(() => ResponseStatusBar(
            response: controller.currentResponse.value,
            isDark: isDark,
            onShowCodeSnippet: () => _showCodeSnippetDialog(context, controller),
          )),

          // Tabs
          ResponseTabs(controller: controller, isDark: isDark),

          // Content
          Expanded(
            child: Container(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Obx(() => _buildContent(context, controller, isDark)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    final response = controller.currentResponse.value;
    final selectedTab = controller.selectedResponseTab.value;

    if (response == null) {
      return const ResponseEmptyState();
    }

    switch (selectedTab) {
      case 'response':
        return ResponseBodyTab(
          response: response,
          isDark: isDark,
          controller: controller,
        );
      case 'headers':
        return ResponseHeadersTab(
          response: response,
          isDark: isDark,
          controller: controller,
        );
      case 'cookies':
        return ResponseCookiesTab(isDark: isDark);
      case 'results':
        return ResponseResultsTab(controller: controller, isDark: isDark);
      case 'docs':
        return ResponseDocsTab(
          controller: controller,
          response: response,
          isDark: isDark,
        );
      case 'code_snippet':
        return ResponseCodeSnippetTab(controller: controller, isDark: isDark);
      default:
        // Handle Messages constants
        if (selectedTab == Messages.response) {
          return ResponseBodyTab(
            response: response,
            isDark: isDark,
            controller: controller,
          );
        }
        if (selectedTab == Messages.headers) {
          return ResponseHeadersTab(
            response: response,
            isDark: isDark,
            controller: controller,
          );
        }
        if (selectedTab == Messages.cookies) {
          return ResponseCookiesTab(isDark: isDark);
        }
        if (selectedTab == Messages.results) {
          return ResponseResultsTab(controller: controller, isDark: isDark);
        }
        if (selectedTab == Messages.docs) {
          return ResponseDocsTab(
            controller: controller,
            response: response,
            isDark: isDark,
          );
        }
        return const SizedBox.shrink();
    }
  }

  void _showCodeSnippetDialog(BuildContext context, HttpController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Code Snippet',
                    style: context.textTheme.titleMedium,
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
                child: ResponseCodeSnippetTab(
                  controller: controller,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
