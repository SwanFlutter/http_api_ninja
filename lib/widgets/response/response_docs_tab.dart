import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_view/flutter_code_view.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';
import '../../models/http_response_model.dart';

class ResponseDocsTab extends StatelessWidget {
  final HttpController controller;
  final HttpResponseModel response;
  final bool isDark;

  const ResponseDocsTab({
    super.key,
    required this.controller,
    required this.response,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isNarrow ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context, isNarrow),
              SizedBox(height: isNarrow ? 16 : 24),
              _buildInfoCards(context, isNarrow),
              SizedBox(height: isNarrow ? 20 : 24),
              _buildSchemaSection(context, isNarrow),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context, bool isNarrow) {
    return Text(
      'API Documentation',
      style: isNarrow
          ? context.textTheme.titleMedium
          : context.textTheme.titleLarge,
    );
  }

  Widget _buildInfoCards(BuildContext context, bool isNarrow) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildInfoCard(
          context,
          'Endpoint',
          controller.url.value,
          Icons.link,
          Colors.blue,
          isNarrow,
        ),
        _buildInfoCard(
          context,
          'Method',
          controller.httpMethod.value,
          Icons.http,
          Colors.green,
          isNarrow,
        ),
        _buildInfoCard(
          context,
          'Status',
          '${response.statusCode}',
          Icons.check_circle,
          Colors.orange,
          isNarrow,
        ),
        _buildInfoCard(
          context,
          'Time',
          response.timeText,
          Icons.timer,
          Colors.purple,
          isNarrow,
        ),
        _buildInfoCard(
          context,
          'Size',
          response.sizeText,
          Icons.data_usage,
          Colors.red,
          isNarrow,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isNarrow,
  ) {
    return Container(
      constraints: BoxConstraints(minWidth: isNarrow ? 140 : 180),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSchemaSection(BuildContext context, bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Response Schema',
              style: isNarrow
                  ? context.textTheme.titleSmall
                  : context.textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: _generateSchema(response.body)),
                );
                controller.showNotification('Schema copied to clipboard', 'success');
              },
              tooltip: 'Copy Schema',
            ),
          ],
        ),
        const SizedBox(height: 12),
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
      return const JsonEncoder.withIndent('  ')
          .convert({'type': 'array', 'items': _getType(data[0])});
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
}
