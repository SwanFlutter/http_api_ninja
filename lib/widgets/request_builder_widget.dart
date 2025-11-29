import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../I18n/messages.dart';
import '../controller/http_controller.dart';
import 'tabs/auth_tab.dart';
import 'tabs/body_tab.dart';
import 'tabs/headers_tab.dart';
import 'tabs/prerun_tab.dart';
import 'tabs/query_tab.dart';
import 'tabs/tests_tab.dart';
import 'welcome_screen_widget.dart';

class RequestBuilderWidget extends StatelessWidget {
  const RequestBuilderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // Show welcome screen if no request is selected
      if (controller.selectedRequest.value == null) {
        return const WelcomeScreenWidget();
      }

      return Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
            right: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
        ),
        child: Column(
          children: [
            // URL Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Base URL indicator
                  Obx(() {
                    final baseUrl = controller.getSelectedRequestBaseUrl();
                    if (baseUrl != null && baseUrl.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 14,
                              color: Colors.orange[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Base URL: ',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                baseUrl,
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: Colors.orange[400],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF3C3C3C)
                              : Colors.white,
                          border: Border.all(
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Obx(
                          () => DropdownButton<String>(
                            value: controller.httpMethod.value,
                            underline: const SizedBox(),
                            dropdownColor: isDark
                                ? const Color(0xFF3C3C3C)
                                : Colors.white,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            items: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']
                                .map(
                                  (method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(
                                      method,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                controller.httpMethod.value = value!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => TextField(
                            controller:
                                TextEditingController(
                                    text: controller.url.value,
                                  )
                                  ..selection = TextSelection.fromPosition(
                                    TextPosition(
                                      offset: controller.url.value.length,
                                    ),
                                  ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? const Color(0xFF3C3C3C)
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? Colors.grey[700]!
                                      : Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              hintText:
                                  controller.getSelectedRequestBaseUrl() != null
                                  ? '/endpoint'
                                  : 'https://api.example.com/endpoint',
                              hintStyle: context.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                            style: context.textTheme.bodySmall,
                            onChanged: (value) => controller.url.value = value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => SizedBox(
                          height: 45,
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.sendRequest(),
                            icon: Icon(
                              controller.isLoading.value
                                  ? Icons.hourglass_empty
                                  : Icons.send,
                              size: 14,
                            ),
                            label: Text(
                              Messages.send.tr,
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Request Tabs
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2D2D2D)
                            : Colors.grey[50],
                      ),
                      child: Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                [
                                  Messages.query,
                                  Messages.headers,
                                  Messages.auth,
                                  Messages.body,
                                  Messages.tests,
                                  Messages.preRun,
                                ].map((tab) {
                                  final isSelected =
                                      controller.selectedRequestTab.value ==
                                      tab;
                                  final count = tab == Messages.headers
                                      ? controller.headersList.length
                                      : null;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: InkWell(
                                      onTap: () =>
                                          controller.selectedRequestTab.value =
                                              tab,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: isSelected
                                                  ? Theme.of(
                                                      context,
                                                    ).primaryColor
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              tab.tr,
                                              style: context
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: isSelected
                                                        ? Theme.of(
                                                            context,
                                                          ).primaryColor
                                                        : Colors.grey[400],
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                            ),
                                            if (count != null && count > 0)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '$count',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (tab == Messages.preRun)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 1,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withValues(alpha: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          2,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'New',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),

                    // Tab Content
                    Expanded(
                      child: Obx(() {
                        final selectedTab = controller.selectedRequestTab.value;

                        if (selectedTab == Messages.query) {
                          return const QueryTab();
                        } else if (selectedTab == Messages.headers) {
                          return const HeadersTab();
                        } else if (selectedTab == Messages.auth) {
                          return const AuthTab();
                        } else if (selectedTab == Messages.body) {
                          return const BodyTab();
                        } else if (selectedTab == Messages.tests) {
                          return const TestsTab();
                        } else if (selectedTab == Messages.preRun) {
                          return const PreRunTab();
                        }

                        return const SizedBox.shrink();
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
