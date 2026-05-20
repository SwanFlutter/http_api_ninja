import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';
import '../../models/http_response_model.dart';

class ResponseHeadersTab extends StatelessWidget {
  final HttpResponseModel response;
  final bool isDark;
  final HttpController controller;

  const ResponseHeadersTab({
    super.key,
    required this.response,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (response.headers.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        _buildHeader(context),
        _buildTableHeader(context),
        Expanded(child: _buildHeadersList(context)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No headers',
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final headersString = response.headers.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');

    return Container(
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
            style: context.textTheme.titleSmall,
          ),
          const Spacer(),
          _buildCopyButton(context, headersString),
        ],
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context, String headersString) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: headersString));
        controller.showNotification('Headers copied to clipboard', 'success');
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              style: context.textTheme.labelSmall?.copyWith(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D30) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 400;

          if (isNarrow) {
            return Text(
              'Header / Value',
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            );
          }

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Header',
                  style: context.textTheme.labelSmall?.copyWith(
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
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeadersList(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: response.headers.length,
          itemBuilder: (context, index) {
            final entry = response.headers.entries.elementAt(index);
            return _buildHeaderRow(context, entry, isNarrow);
          },
        );
      },
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    MapEntry<String, String> entry,
    bool isNarrow,
  ) {
    if (isNarrow) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              entry.key,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontFamily: 'Courier',
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              entry.value,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.purple[300] : Colors.purple[700],
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
      );
    }

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
              style: context.textTheme.bodySmall?.copyWith(
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
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.purple[300] : Colors.purple[700],
                fontFamily: 'Courier',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
