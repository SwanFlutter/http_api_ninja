import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';
import 'package:http_api_ninja/models/collection_model.dart';

import '../I18n/messages.dart';
import '../controller/http_controller.dart';
import '../models/http_request_model.dart';
import 'about_dialog.dart';
import 'collections_io_dialog.dart';
import 'environment_tab.dart';
import 'history_tab.dart';
import 'import_dialog.dart';
import 'settings_dialog.dart';
import 'update_button_widget.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252526) : Colors.grey[100],
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showNewRequestDialog(context, controller),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      Messages.newRequest.tr,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Get.isDarkMode ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showNewCollectionDialog(context, controller),
                    icon: const Icon(Icons.create_new_folder, size: 18),
                    label: Text(
                      'New Collection',
                      style: context.textTheme.bodyMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showImportDialog(context),
                    icon: const Icon(Icons.input, size: 18),
                    label: Text(
                      Messages.import.tr,
                      style: context.textTheme.bodyMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => CollectionsIoDialog.showImport(context),
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: Text(
                      'Import All',
                      style: context.textTheme.bodyMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => CollectionsIoDialog.showExport(context),
                    icon: const Icon(Icons.ios_share, size: 18),
                    label: Text(
                      'Export All',
                      style: context.textTheme.bodyMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: Obx(
              () => Row(
                children:
                    [Messages.activity, Messages.collections, Messages.env].map(
                      (tab) {
                        final isSelected = controller.selectedTab.value == tab;
                        return Expanded(
                          child: InkWell(
                            onTap: () => controller.selectedTab.value = tab,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                              child: Text(
                                tab.tr,
                                textAlign: TextAlign.center,
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[400],
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: Messages.filterCollections.tr,
                hintStyle: context.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF3C3C3C) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              style: context.textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Obx(() {
              final selectedTab = controller.selectedTab.value;

              // Activity/History Tab
              if (selectedTab == Messages.activity) {
                return const HistoryTab();
              }

              // Collections Tab
              if (selectedTab == Messages.collections) {
                // Trigger rebuild when selectedRequest changes
                controller.selectedRequest.value;
                return _buildCollectionsTab(controller);
              }

              // Env Tab
              if (selectedTab == Messages.env) {
                return const EnvironmentTab();
              }

              return const SizedBox.shrink();
            }),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.person_outline, size: 20),
                  onPressed: () {},
                  color: Colors.grey[400],
                  tooltip: 'Profile',
                ),
                const UpdateButtonWidget(),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const AppAboutDialog(),
                  ),
                  color: Colors.grey[400],
                  tooltip: 'About',
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const SettingsDialog(),
                  ),
                  color: Colors.grey[400],
                  tooltip: 'Settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewCollectionDialog(
    BuildContext context,
    HttpController controller,
  ) {
    final nameController = TextEditingController();
    final baseUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Collection', style: context.textTheme.titleSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Collection Name',
                hintText: 'Enter collection name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: baseUrlController,
              decoration: const InputDecoration(
                labelText: 'Base URL (Optional)',
                hintText: 'https://api.example.com',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.addCollection(
                  nameController.text,
                  baseUrl: baseUrlController.text.isNotEmpty
                      ? baseUrlController.text
                      : null,
                );
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const ImportDialog());
  }

  void _showNewRequestDialog(BuildContext context, HttpController controller) {
    final nameController = TextEditingController();
    String? selectedCollectionId;
    String selectedMethod = 'GET';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Build collection tree inside StatefulBuilder so setState works correctly
          Widget buildCollectionTree(
            List<CollectionModel> cols, {
            double depth = 0,
          }) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cols.map((collection) {
                return ExpansionTile(
                  tilePadding: EdgeInsets.only(left: depth * 16 + 8, right: 8),
                  initiallyExpanded: true,
                  title: Row(
                    children: [
                      Radio<String>(
                        value: collection.id,
                        groupValue: selectedCollectionId,
                        onChanged: (value) =>
                            setState(() => selectedCollectionId = value),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(
                            () => selectedCollectionId = collection.id,
                          ),
                          child: Text(
                            collection.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: collection.folders.isNotEmpty
                      ? [
                          buildCollectionTree(
                            collection.folders,
                            depth: depth + 1,
                          ),
                        ]
                      : [],
                );
              }).toList(),
            );
          }

          return AlertDialog(
            title: Text('New Request', style: context.textTheme.titleSmall),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Request Name',
                        hintText: 'Enter request name',
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Method',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'].map((
                        m,
                      ) {
                        final isSelected = selectedMethod == m;
                        final color = controller.getMethodColor(m);
                        return ChoiceChip(
                          label: Text(m),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => selectedMethod = m);
                            }
                          },
                          selectedColor: color.withValues(alpha: 0.2),
                          side: isSelected
                              ? BorderSide(color: color, width: 2)
                              : BorderSide(color: Colors.grey[300]!),
                          labelStyle: TextStyle(
                            color: isSelected ? color : Colors.grey[600],
                            fontWeight: isSelected ? FontWeight.bold : null,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Collection',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: buildCollectionTree(controller.collections),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      selectedCollectionId != null) {
                    final request = HttpRequestModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      method: selectedMethod,
                      url: '',
                      createdAt: DateTime.now(),
                    );
                    controller.addRequest(selectedCollectionId!, request);
                    Get.back();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCollectionsTab(HttpController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: controller.collections.length,
      itemBuilder: (context, index) {
        final collection = controller.collections[index];
        return _buildCollectionFolder(context, collection, controller);
      },
    );
  }

  Widget _buildCollectionFolder(
    BuildContext context,
    CollectionModel collection,
    HttpController controller, {
    double depth = 0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => controller.toggleCollection(collection.id),
          child: Padding(
            padding: EdgeInsets.only(
              left: 8 + (depth * 12),
              right: 8,
              top: 6,
              bottom: 6,
            ),
            child: Row(
              children: [
                Icon(
                  collection.isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 18,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Icon(
                  collection.folders.isNotEmpty
                      ? Icons.folder
                      : Icons.folder_open,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collection.name,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: depth == 0
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                      if (depth == 0 &&
                          collection.baseUrl != null &&
                          collection.baseUrl!.isNotEmpty)
                        Text(
                          collection.baseUrl!,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: Colors.orange[400],
                            fontSize: 10,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (depth ==
                    0) // Only show menu for top-level collections for now
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Rename'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'editBaseUrl',
                        child: Row(
                          children: [
                            Icon(Icons.link, size: 16, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Edit Base URL'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'export',
                        child: Row(
                          children: [
                            Icon(
                              Icons.ios_share,
                              size: 16,
                              color: Colors.blue[400],
                            ),
                            const SizedBox(width: 8),
                            const Text('Export (Postman)'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'rename') {
                        _showRenameCollectionDialog(
                          context,
                          controller,
                          collection.id,
                          collection.name,
                        );
                      } else if (value == 'editBaseUrl') {
                        _showEditBaseUrlDialog(
                          context,
                          controller,
                          collection.id,
                          collection.baseUrl,
                        );
                      } else if (value == 'export') {
                        controller.exportCollection(collection);
                      } else if (value == 'delete') {
                        _showDeleteCollectionDialog(
                          context,
                          controller,
                          collection.id,
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
        if (collection.isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 12 + (depth * 4)),
            child: Column(
              children: [
                // Render Sub-folders
                ...collection.folders.map(
                  (folder) => _buildCollectionFolder(
                    context,
                    folder,
                    controller,
                    depth: depth + 1,
                  ),
                ),
                // Render Requests
                ...collection.requests.map<Widget>((req) {
                  final isSelected =
                      controller.selectedRequest.value?.id == req.id;
                  return InkWell(
                    onTap: () => controller.selectRequest(req),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 20 + (depth * 12),
                        right: 8,
                        top: 6,
                        bottom: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? const Color(0xFF37373D)
                                  : Colors.grey[200])
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getMethodColor(
                                req.method,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              req.method,
                              style: TextStyle(
                                fontSize: 10,
                                color: _getMethodColor(req.method),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              req.name,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_horiz,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'delete') {
                                // For now, we only support deleting from top-level collections
                                // because the controller needs the collectionId
                                controller.deleteRequest(collection.id, req.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  void _showRenameCollectionDialog(
    BuildContext context,
    HttpController controller,
    String collectionId,
    String currentName,
  ) {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Collection', style: context.textTheme.titleSmall),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Collection Name',
            hintText: 'Enter new name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.renameCollection(collectionId, nameController.text);
                Get.back();
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showEditBaseUrlDialog(
    BuildContext context,
    HttpController controller,
    String collectionId,
    String? currentBaseUrl,
  ) {
    final baseUrlController = TextEditingController(text: currentBaseUrl ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Base URL', style: context.textTheme.titleSmall),
        content: TextField(
          controller: baseUrlController,
          decoration: const InputDecoration(
            labelText: 'Base URL',
            hintText: 'https://api.example.com',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.updateCollectionBaseUrl(
                collectionId,
                baseUrlController.text.isNotEmpty
                    ? baseUrlController.text
                    : null,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCollectionDialog(
    BuildContext context,
    HttpController controller,
    String collectionId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Collection', style: context.textTheme.titleSmall),
        content: Text(
          'Are you sure you want to delete this collection?',
          style: context.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.deleteCollection(collectionId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(String method) {
    final controller = Get.smartFind<HttpController>();
    return controller.getMethodColor(method);
  }
}
