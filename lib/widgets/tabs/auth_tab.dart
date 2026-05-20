import 'package:flutter/material.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class AuthTab extends StatelessWidget {
  const AuthTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.smartFind<HttpController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Auth Type Selector
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
          child: Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['None', 'Basic', 'Bearer', 'OAuth 2.0', 'API Key'].map(
                (type) {
                  final isSelected = controller.authType.value == type;
                  return ChoiceChip(
                    label: Text(type, style: context.textTheme.labelMedium),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        controller.authType.value = type;
                      }
                    },
                  );
                },
              ).toList(),
            ),
          ),
        ),

        // Auth Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              switch (controller.authType.value) {
                case 'None':
                  return _buildNoneAuth(context);
                case 'Basic':
                  return _buildBasicAuth(context, controller);
                case 'Bearer':
                  return _buildBearerAuth(context, controller);
                case 'OAuth 2.0':
                  return _buildOAuthAuth(context, controller);
                case 'API Key':
                  return _buildApiKeyAuth(context, controller);
                default:
                  return _buildNoneAuth(context);
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildNoneAuth(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_open, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Authentication Selected',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicAuth(BuildContext context, HttpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Basic Authentication', style: context.textTheme.titleSmall),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => controller.authUsername.value = value,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: (value) => controller.authPassword.value = value,
        ),
      ],
    );
  }

  Widget _buildBearerAuth(BuildContext context, HttpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bearer Token', style: context.textTheme.titleSmall),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Token',
            border: OutlineInputBorder(),
            hintText: 'Enter your bearer token',
          ),
          maxLines: 3,
          onChanged: (value) => controller.authToken.value = value,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Prefix',
            border: OutlineInputBorder(),
          ),
          initialValue: 'Bearer',
          items: [
            'Bearer',
            'Token',
            'Custom',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildOAuthAuth(BuildContext context, HttpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('OAuth 2.0', style: context.textTheme.titleSmall),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Grant Type',
            border: OutlineInputBorder(),
          ),
          initialValue: 'Authorization Code',
          items: [
            'Authorization Code',
            'Password',
            'Client Credentials',
            'Implicit',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Auth URL',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Token URL',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Client ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Client Secret',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Scope',
            border: OutlineInputBorder(),
            hintText: 'read write',
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.key),
          label: const Text('Generate Token'),
        ),
      ],
    );
  }

  Widget _buildApiKeyAuth(BuildContext context, HttpController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('API Key', style: context.textTheme.titleSmall),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Key',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Add to',
            border: OutlineInputBorder(),
          ),
          initialValue: 'Header',
          items: [
            'Header',
            'Query Params',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
