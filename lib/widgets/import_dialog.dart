// ignore_for_file: unused_field, unnecessary_to_list_in_spreads

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_x_master/get_x_master.dart';

import '../I18n/messages.dart';
import '../config/import_utils.dart';
import '../config/postman_collection_utils.dart';
import '../controller/http_controller.dart';
import '../models/collection_model.dart';
import '../models/http_request_model.dart';

class ImportDialog extends StatefulWidget {
  const ImportDialog({super.key});

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedType = 'JSON';
  String? _selectedCollectionId;
  final List<String> _importTypes = [
    'curl',
    'gRpcurl',
    'Raw',
    'text',
    'url',
    'JSON',
  ];
  bool _isImporting = false;

  // Track actual text separately to avoid rebuilding TextField on every keystroke
  String _inputText = '';
  bool _isLargeText = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final len = _inputController.text.length;
    final nowLarge = len > 50000;
    if (nowLarge != _isLargeText) {
      setState(() {
        _isLargeText = nowLarge;
      });
    }
    _inputText = _inputController.text;
  }

  @override
  void dispose() {
    _inputController.removeListener(_onTextChanged);
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.input, size: 20),
          const SizedBox(width: 8),
          Text(Messages.import.tr, style: context.textTheme.titleSmall),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: _isImporting
            ? SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      Text(
                        'Processing...',
                        style: context.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Parsing data in background. Please wait...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Import Type:',
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _pasteFromClipboard,
                        icon: const Icon(Icons.content_paste, size: 16),
                        label: const Text(
                          'Paste from Clipboard',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _importTypes.map((type) {
                        final isSelected = _selectedType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedType = type;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      // Use a scrollable container for large text to avoid
                      // rendering the entire content at once
                      _isLargeText
                          ? _buildLargeTextInput(isDark)
                          : _buildNormalTextInput(isDark),
                      if (_isLargeText)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(_inputController.text.length / 1024).toStringAsFixed(0)} KB',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: _selectedCollectionId,
                      style: context.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: Messages.selectCollection.tr,
                        hintText: Messages.importAsNewCollection.tr,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(Messages.importAsNewCollection.tr),
                        ),
                        ...controller.collections
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ),
                            )
                            .toList(),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedCollectionId = value),
                    ),
                  ),
                ],
              ),
      ),
      actions: _isImporting
          ? []
          : [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _handleImport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(Messages.import.tr),
              ),
            ],
    );
  }

  /// Normal text input for small content
  Widget _buildNormalTextInput(bool isDark) {
    return TextField(
      controller: _inputController,
      maxLines: 10,
      enableSuggestions: false,
      autocorrect: false,
      spellCheckConfiguration: const SpellCheckConfiguration.disabled(),
      decoration: InputDecoration(
        hintText: 'Paste your $_selectedType here...',
        filled: true,
        fillColor: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: const EdgeInsets.all(12),
        helperText:
            'Tip: For large data use "Paste from Clipboard" button above.',
      ),
      style: context.textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
        fontSize: 12,
      ),
    );
  }

  /// For large text: show a read-only summary + clear button instead of
  /// rendering thousands of lines in a TextField (which causes jank/crash).
  Widget _buildLargeTextInput(bool isDark) {
    final lines = '\n'.allMatches(_inputController.text).length + 1;
    final sizeKb = (_inputController.text.length / 1024).toStringAsFixed(1);
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[400]!,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Preview: first ~500 chars only
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Text(
                _inputController.text.length > 500
                    // ignore: unnecessary_brace_in_string_interps
                    ? '${_inputController.text.substring(0, 500)}\n\n... [${lines} lines / $sizeKb KB total — ready to import]'
                    : _inputController.text,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 14, color: Colors.green[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '$lines lines · $sizeKb KB loaded',
                    style: const TextStyle(fontSize: 11, color: Colors.green),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _inputController.clear();
                    setState(() {
                      _inputText = '';
                      _isLargeText = false;
                    });
                  },
                  icon: const Icon(Icons.clear, size: 14),
                  label: const Text('Clear', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(foregroundColor: Colors.red[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    // Show loading indicator while reading clipboard
    setState(() => _isImporting = true);

    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null && data!.text!.isNotEmpty) {
        // Set text without triggering multiple rebuilds
        // Use a microtask to let the loading state render first
        await Future.microtask(() {
          _inputController.value = TextEditingValue(
            text: data.text!,
            selection: TextSelection.collapsed(offset: data.text!.length),
          );
          _inputText = data.text!;
          _isLargeText = data.text!.length > 50000;
        });
      }
    } catch (e) {
      debugPrint("Clipboard error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not access clipboard: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _handleImport() async {
    final controller = Get.smartFind<HttpController>();
    // Use the tracked text to avoid reading from controller on UI thread
    final input = _inputController.text;
    final type = _selectedType;

    if (input.trim().isEmpty) {
      controller.showNotification('Input is empty', 'info');
      return;
    }

    setState(() => _isImporting = true);

    // Let the loading UI render before starting heavy work
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      // Run parsing in a background isolate so UI stays responsive
      final result = await compute(_parseInBackground, {
        'type': type,
        'input': input,
      });

      if (!mounted) return;

      if (result is CollectionModel) {
        controller.importCollection(result);
        Get.back();
      } else if (result is List<CollectionModel>) {
        for (var col in result) {
          controller.importCollection(col);
        }
        Get.back();
      } else if (result is HttpRequestModel) {
        if (_selectedCollectionId != null) {
          controller.addRequest(_selectedCollectionId!, result);
          controller.selectRequest(result);
          Get.back();
          controller.showNotification(
            'Request imported successfully',
            'success',
          );
        } else {
          controller.showNotification(
            'Please select a collection for single request',
            'info',
          );
          setState(() => _isImporting = false);
        }
      } else {
        controller.showNotification(
          'Failed to parse input. Check the format and try again.',
          'error',
        );
        setState(() => _isImporting = false);
      }
    } catch (e) {
      debugPrint('Import error: $e');
      if (mounted) {
        controller.showNotification('Import error: ${_shortError(e)}', 'error');
        setState(() => _isImporting = false);
      }
    }
  }

  String _shortError(Object e) {
    final msg = e.toString();
    return msg.length > 120 ? '${msg.substring(0, 120)}...' : msg;
  }

  /// Top-level function required by [compute] — must be static or top-level.
  static dynamic _parseInBackground(Map<String, String> data) {
    try {
      final type = data['type']!.toLowerCase();
      final input = data['input']!;

      if (type == 'json') {
        try {
          final collections = PostmanCollectionUtils.parseImportPayload(input);
          if (collections.length > 1) return collections;
          if (collections.length == 1) return collections.first;
        } catch (_) {}
      }

      return ImportUtils.parseImport(data['type']!, input);
    } catch (e) {
      return null;
    }
  }
}
