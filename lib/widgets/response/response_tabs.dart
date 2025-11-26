import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../I18n/messages.dart';
import '../../controller/http_controller.dart';

class ResponseTabs extends StatelessWidget {
  final HttpController controller;
  final bool isDark;

  const ResponseTabs({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: _buildTabs(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context) {
    final tabs = [
      Messages.response,
      Messages.headers,
      Messages.cookies,
      Messages.results,
      Messages.docs,
      'code_snippet',
    ];

    return tabs.map((tab) {
      final isSelected = controller.selectedResponseTab.value == tab;
      final count = _getTabCount(tab);
      final isCodeTab = tab == 'code_snippet';

      return _buildTab(context, tab, isSelected, count, isCodeTab);
    }).toList();
  }

  int? _getTabCount(String tab) {
    if (tab == Messages.headers) {
      return controller.currentResponse.value?.headers.length ?? 0;
    }
    if (tab == Messages.results) {
      return controller.testsList.length;
    }
    return null;
  }

  Widget _buildTab(
    BuildContext context,
    String tab,
    bool isSelected,
    int? count,
    bool isCodeTab,
  ) {
    return InkWell(
      onTap: () => controller.selectedResponseTab.value = tab,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          mainAxisSize: MainAxisSize.min,
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
                style: context.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            if (count != null && count > 0) _buildBadge(context, count),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
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
    );
  }
}
