import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../I18n/messages.dart';
import '../controller/http_controller.dart';
import '../models/http_request_model.dart';
import 'environment_tab.dart';
import 'history_tab.dart';
import 'settings_dialog.dart';
import 'update_button_widget.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
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
                ),
                const UpdateButtonWidget(),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const SettingsDialog(),
                  ),
                  color: Colors.grey[400],
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Collection', style: context.textTheme.titleSmall),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Collection Name',
            hintText: 'Enter collection name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.addCollection(nameController.text);
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showNewRequestDialog(BuildContext context, HttpController controller) {
    final nameController = TextEditingController();
    String? selectedCollectionId;
    String selectedMethod = 'GET';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('New Request', style: context.textTheme.titleSmall),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
              DropdownButtonFormField<String>(
                initialValue: selectedMethod,
                decoration: const InputDecoration(labelText: 'Method'),
                items: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedMethod = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Collection'),
                  items: controller.collections
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (value) => selectedCollectionId = value,
                ),
              ),
            ],
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
        ),
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
    collection,
    HttpController controller,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => controller.toggleCollection(collection.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                Icon(Icons.folder, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    collection.name,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: collection.requests.map<Widget>((req) {
                final isSelected =
                    controller.selectedRequest.value?.id == req.id;
                return InkWell(
                  onTap: () => controller.selectRequest(req),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
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
                              fontSize: 11,
                              color: _getMethodColor(req.method),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            req.name,
                            style: const TextStyle(fontSize: 13),
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
                              controller.deleteRequest(collection.id, req.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
    switch (method) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
