import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:image_picker_master/image_picker_master.dart';
import 'package:file_picker/file_picker.dart' as fp;

import '../controller/http_controller.dart';
import '../widgets/global/custom_toast.dart';

/// Bulk import/export collections (Postman v2.1 + app backup).
class CollectionsIoDialog extends StatefulWidget {
  final bool exportMode;

  const CollectionsIoDialog({super.key, required this.exportMode});

  static Future<void> showExport(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const CollectionsIoDialog(exportMode: true),
    );
  }

  static Future<void> showImport(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const CollectionsIoDialog(exportMode: false),
    );
  }

  @override
  State<CollectionsIoDialog> createState() => _CollectionsIoDialogState();
}

class _CollectionsIoDialogState extends State<CollectionsIoDialog> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  String _exportFormat = 'postman';
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  void dispose() {
    _inputController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        widget.exportMode ? 'Export All Collections' : 'Import All Collections',
        style: context.textTheme.titleSmall,
      ),
      content: SizedBox(
        width: 560,
        child: widget.exportMode
            ? _buildExportContent(context, controller, isDark)
            : _buildImportContent(context, controller, isDark),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildExportContent(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${controller.collections.length} collection(s) ready to export.',
          style: context.textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _exportFormat,
          decoration: const InputDecoration(
            labelText: 'Format',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: const TextStyle(fontSize: 13),
          items: const [
            DropdownMenuItem(
              value: 'postman',
              child: Text('Postman v2.1 (import in Postman)', style: TextStyle(fontSize: 13)),
            ),
            DropdownMenuItem(
              value: 'backup',
              child: Text('HTTP API Ninja backup', style: TextStyle(fontSize: 13)),
            ),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _exportFormat = v);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _fileNameController,
          decoration: const InputDecoration(
            labelText: 'File Name',
            hintText: 'collections_export',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.collections.isEmpty || _isExporting
                    ? null
                    : () => _exportToFile(controller),
                icon: _isExporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download, size: 18),
                label: Text(_isExporting ? 'Exporting...' : 'Export'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Click Export to choose save location.',
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildImportContent(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a JSON file to import (Postman collection or HTTP API Ninja backup).',
          style: context.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _isImporting ? null : () => _pickFileForImport(controller),
          icon: _isImporting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.file_open, size: 18),
          label: Text(_isImporting ? 'Importing...' : 'Select File'),
        ),
        const SizedBox(height: 12),
        Text(
          'Supported formats: .json files from Postman or HTTP API Ninja',
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Future<void> _exportToFile(HttpController controller) async {
    final fileName = _fileNameController.text.trim();
    if (fileName.isEmpty) {
      CustomToast.warning(title: 'Please enter a file name');
      return;
    }

    setState(() => _isExporting = true);

    try {
      // Get the JSON data
      String jsonData;
      if (_exportFormat == 'postman') {
        jsonData = controller.getAllCollectionsPostmanJson();
      } else {
        jsonData = controller.getAllCollectionsBackupJson();
      }

      // Open save dialog
      final result = await fp.FilePicker.platform.saveFile(
        dialogTitle: 'Save Collections Export',
        fileName: '$fileName.json',
        type: fp.FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) {
        // User cancelled
        setState(() => _isExporting = false);
        return;
      }

      // Write to file
      final file = File(result);
      await file.writeAsString(jsonData);

      CustomToast.success(
        title: 'Export successful',
        description: 'File saved to: ${file.path}',
      );
      Get.back();
    } catch (e) {
      CustomToast.error(
        title: 'Export failed',
        description: e.toString(),
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _pickFileForImport(HttpController controller) async {
    setState(() => _isImporting = true);

    try {
      final files = await ImagePickerMaster.instance.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
        withData: false,
      );

      if (files != null && files.isNotEmpty) {
        final file = files.first;
        final fileContent = await File(file.path).readAsString();
        
        controller.importCollectionsFromJson(fileContent);
        Get.back();
      }
    } catch (e) {
      CustomToast.error(
        title: 'Import failed',
        description: e.toString(),
      );
    } finally {
      setState(() => _isImporting = false);
    }
  }
}
