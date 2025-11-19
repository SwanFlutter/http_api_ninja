import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../I18n/messages.dart';
import '../controller/http_controller.dart';
import '../models/http_request_model.dart';
import 'settings_dialog.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();
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
                    child: Text(Messages.newRequest.tr),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showNewCollectionDialog(context, controller),
                    icon: const Icon(Icons.create_new_folder, size: 18),
                    label: const Text('New Collection'),
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
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
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
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Obx(() {
              final selectedTab = controller.selectedTab.value;

              // Activity Tab
              if (selectedTab == Messages.activity) {
                return _buildActivityTab(controller, isDark);
              }

              // Collections Tab
              if (selectedTab == Messages.collections) {
                return _buildCollectionsTab(controller);
              }

              // Env Tab
              if (selectedTab == Messages.env) {
                return _buildEnvTab(isDark);
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
        title: const Text('New Collection'),
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
          title: const Text('New Request'),
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

  Widget _buildActivityTab(HttpController controller, bool isDark) {
    // Show recent requests from all collections
    final allRequests = <HttpRequestModel>[];
    for (var collection in controller.collections) {
      allRequests.addAll(collection.requests);
    }
    allRequests.sort(
      (a, b) =>
          (b.lastUsed ?? b.createdAt).compareTo(a.lastUsed ?? a.createdAt),
    );

    if (allRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No recent activity',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: allRequests.length > 20 ? 20 : allRequests.length,
      itemBuilder: (context, index) {
        final req = allRequests[index];
        final isSelected = controller.selectedRequest.value?.id == req.id;

        return InkWell(
          onTap: () => controller.selectRequest(req),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark
                        ? const Color(0xFF37373D)
                        : Colors.blue.withValues(alpha: 0.1))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: isSelected
                  ? Border.all(color: Colors.blue, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getMethodColor(req.method).withValues(alpha: 0.2),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.name,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        req.url.isEmpty ? 'No URL' : req.url,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildEnvTab(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Environment Variables',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon...',
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
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
                    style: const TextStyle(
                      fontSize: 13,
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
                    if (value == 'delete') {
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

  void _showDeleteCollectionDialog(
    BuildContext context,
    HttpController controller,
    String collectionId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: const Text('Are you sure you want to delete this collection?'),
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
