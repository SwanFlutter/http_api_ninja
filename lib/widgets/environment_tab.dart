import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_x_master/get_x_master.dart';

import '../controller/http_controller.dart';
import '../models/environment_model.dart';

class EnvironmentTab extends StatelessWidget {
  const EnvironmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Environment selector and actions
        _buildHeader(context, controller, isDark),
        
        // Tabs for Environment and Global variables
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: const [
                    Tab(text: 'Environment'),
                    Tab(text: 'Global'),
                  ],
                  labelStyle: context.textTheme.labelSmall,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildEnvironmentVariables(context, controller, isDark),
                      _buildGlobalVariables(context, controller, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, HttpController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          // Environment dropdown
          Obx(() => DropdownButtonFormField<String>(
            value: controller.activeEnvironment.value?.id,
            decoration: InputDecoration(
              labelText: 'Active Environment',
              labelStyle: context.textTheme.labelSmall,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              prefixIcon: Icon(
                Icons.cloud_outlined,
                size: 18,
                color: controller.activeEnvironment.value != null
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
            items: controller.environments.map((env) => DropdownMenuItem(
              value: env.id,
              child: Row(
                children: [
                  if (env.isActive)
                    const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  if (env.isActive) const SizedBox(width: 8),
                  Text(env.name, style: context.textTheme.bodySmall),
                ],
              ),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setActiveEnvironment(value);
              }
            },
          )),
          const SizedBox(height: 8),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAddEnvironmentDialog(context, controller),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text('New', style: context.textTheme.labelSmall),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showImportDialog(context, controller),
                  icon: const Icon(Icons.upload, size: 16),
                  label: Text('Import', style: context.textTheme.labelSmall),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentVariables(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    return Obx(() {
      final activeEnv = controller.activeEnvironment.value;
      
      if (activeEnv == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No environment selected',
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
        );
      }

      final variables = activeEnv.variables.entries.toList();

      return Column(
        children: [
          // Environment info and actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.folder, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activeEnv.name,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () => _showRenameEnvironmentDialog(
                    context, controller, activeEnv,
                  ),
                  tooltip: 'Rename',
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.download, size: 16),
                  onPressed: () => _exportEnvironment(context, controller, activeEnv.id),
                  tooltip: 'Export',
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                  onPressed: () => _showDeleteEnvironmentDialog(
                    context, controller, activeEnv.id,
                  ),
                  tooltip: 'Delete',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          
          // Add variable button
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddVariableDialog(
                  context, controller, activeEnv.id, false,
                ),
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add Variable', style: context.textTheme.labelSmall),
              ),
            ),
          ),
          
          // Variables list
          Expanded(
            child: variables.isEmpty
                ? Center(
                    child: Text(
                      'No variables defined',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: variables.length,
                    itemBuilder: (context, index) {
                      final entry = variables[index];
                      return _buildVariableItem(
                        context,
                        controller,
                        activeEnv.id,
                        entry.key,
                        entry.value,
                        isDark,
                        false,
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildGlobalVariables(
    BuildContext context,
    HttpController controller,
    bool isDark,
  ) {
    return Obx(() {
      final variables = controller.globalVariables.value.variables.entries.toList();

      return Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.public, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Global Variables',
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${variables.length} variables',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          
          // Add variable button
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAddVariableDialog(
                  context, controller, '', true,
                ),
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add Global Variable', style: context.textTheme.labelSmall),
              ),
            ),
          ),
          
          // Variables list
          Expanded(
            child: variables.isEmpty
                ? Center(
                    child: Text(
                      'No global variables defined',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: variables.length,
                    itemBuilder: (context, index) {
                      final entry = variables[index];
                      return _buildVariableItem(
                        context,
                        controller,
                        '',
                        entry.key,
                        entry.value,
                        isDark,
                        true,
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildVariableItem(
    BuildContext context,
    HttpController controller,
    String envId,
    String key,
    String value,
    bool isDark,
    bool isGlobal,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '{{$key}}'));
                  Get.snackbar('Copied', '{{$key}} copied to clipboard');
                },
                tooltip: 'Copy variable syntax',
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () => _showEditVariableDialog(
                  context, controller, envId, key, value, isGlobal,
                ),
                tooltip: 'Edit',
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                onPressed: () {
                  if (isGlobal) {
                    controller.deleteGlobalVariable(key);
                  } else {
                    controller.deleteEnvironmentVariable(envId, key);
                  }
                },
                tooltip: 'Delete',
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddEnvironmentDialog(BuildContext context, HttpController controller) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Environment', style: context.textTheme.titleSmall),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Environment Name',
            hintText: 'e.g., Development, Staging, Production',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.addEnvironment(nameController.text);
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameEnvironmentDialog(
    BuildContext context,
    HttpController controller,
    EnvironmentModel env,
  ) {
    final nameController = TextEditingController(text: env.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename Environment', style: context.textTheme.titleSmall),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Environment Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.renameEnvironment(env.id, nameController.text);
                Get.back();
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteEnvironmentDialog(
    BuildContext context,
    HttpController controller,
    String envId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Environment', style: context.textTheme.titleSmall),
        content: const Text('Are you sure you want to delete this environment?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.deleteEnvironment(envId);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddVariableDialog(
    BuildContext context,
    HttpController controller,
    String envId,
    bool isGlobal,
  ) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isGlobal ? 'Add Global Variable' : 'Add Variable',
          style: context.textTheme.titleSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Variable Name',
                hintText: 'e.g., base_url, api_key',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                hintText: 'e.g., https://api.example.com',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty) {
                if (isGlobal) {
                  controller.addGlobalVariable(
                    keyController.text,
                    valueController.text,
                  );
                } else {
                  controller.addEnvironmentVariable(
                    envId,
                    keyController.text,
                    valueController.text,
                  );
                }
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditVariableDialog(
    BuildContext context,
    HttpController controller,
    String envId,
    String oldKey,
    String oldValue,
    bool isGlobal,
  ) {
    final keyController = TextEditingController(text: oldKey);
    final valueController = TextEditingController(text: oldValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Variable', style: context.textTheme.titleSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(labelText: 'Variable Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Value'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty) {
                if (isGlobal) {
                  controller.updateGlobalVariable(
                    oldKey,
                    keyController.text,
                    valueController.text,
                  );
                } else {
                  controller.updateEnvironmentVariable(
                    envId,
                    oldKey,
                    keyController.text,
                    valueController.text,
                  );
                }
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, HttpController controller) {
    final jsonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Import Environment', style: context.textTheme.titleSmall),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: jsonController,
            decoration: const InputDecoration(
              labelText: 'JSON',
              hintText: 'Paste environment JSON here...',
              border: OutlineInputBorder(),
            ),
            maxLines: 10,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (jsonController.text.isNotEmpty) {
                controller.importEnvironment(jsonController.text);
                Get.back();
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _exportEnvironment(
    BuildContext context,
    HttpController controller,
    String envId,
  ) {
    final json = controller.exportEnvironment(envId);
    Clipboard.setData(ClipboardData(text: json));
    Get.snackbar('Exported', 'Environment JSON copied to clipboard');
  }
}
