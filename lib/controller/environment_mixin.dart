import 'dart:convert';
import 'package:get_x_master/get_x_master.dart';
import 'package:get_x_storage/get_x_storage.dart';
import '../models/environment_model.dart';

mixin EnvironmentMixin {
  final storage = GetXStorage();

  // Environment Variables
  final RxList<EnvironmentModel> environments = <EnvironmentModel>[].obs;
  final Rx<EnvironmentModel?> activeEnvironment = Rx<EnvironmentModel?>(null);
  final Rx<GlobalVariablesModel> globalVariables = GlobalVariablesModel().obs;

  // These will be provided by the main controller or other mixins
  void showNotification(String message, String type);

  void loadEnvironments() {
    // Load environments
    final savedEnvs = storage.readList<Map<String, dynamic>>(
      key: 'environments',
    );
    if (savedEnvs != null && savedEnvs.isNotEmpty) {
      environments.value = savedEnvs
          .map((e) => EnvironmentModel.fromJson(e))
          .toList();
      // Set active environment
      final active = environments.cast<EnvironmentModel>().firstWhere(
        (e) => e.isActive,
        orElse: () => environments.first,
      );
      activeEnvironment.value = active;
    } else {
      // Create default environments
      _initializeDefaultEnvironments();
    }

    // Load global variables
    final savedGlobals = storage.read<Map<String, dynamic>>(
      key: 'globalVariables',
    );
    if (savedGlobals != null) {
      globalVariables.value = GlobalVariablesModel.fromJson(savedGlobals);
    }
  }

  void _initializeDefaultEnvironments() {
    environments.addAll([
      EnvironmentModel(
        id: 'dev',
        name: 'Development',
        variables: {
          'api_version': 'v1',
        },
        isActive: true,
        createdAt: DateTime.now(),
      ),
      EnvironmentModel(
        id: 'staging',
        name: 'Staging',
        variables: {
          'base_url': 'https://staging.example.com',
          'api_version': 'v1',
        },
        createdAt: DateTime.now(),
      ),
      EnvironmentModel(
        id: 'prod',
        name: 'Production',
        variables: {'base_url': 'https://api.example.com', 'api_version': 'v1'},
        createdAt: DateTime.now(),
      ),
    ]);
    activeEnvironment.value = environments.first;
    saveEnvironments();
  }

  void saveEnvironments() {
    storage.writeList(
      key: 'environments',
      value: environments.map((e) => e.toJson()).toList(),
    );
  }

  void saveGlobalVariables() {
    storage.write(
      key: 'globalVariables',
      value: globalVariables.value.toJson(),
    );
  }

  void addEnvironment(String name) {
    final env = EnvironmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      variables: {},
      createdAt: DateTime.now(),
    );
    environments.add(env);
    saveEnvironments();
  }

  void deleteEnvironment(String id) {
    environments.removeWhere((e) => e.id == id);
    if (activeEnvironment.value?.id == id) {
      activeEnvironment.value = environments.isNotEmpty
          ? environments.first
          : null;
      if (activeEnvironment.value != null) {
        setActiveEnvironment(activeEnvironment.value!.id);
      }
    }
    saveEnvironments();
  }

  void renameEnvironment(String id, String newName) {
    final index = environments.indexWhere((e) => e.id == id);
    if (index != -1) {
      environments[index] = environments[index].copyWith(
        name: newName,
        updatedAt: DateTime.now(),
      );
      saveEnvironments();
    }
  }

  void setActiveEnvironment(String id) {
    for (var i = 0; i < environments.length; i++) {
      environments[i] = environments[i].copyWith(
        isActive: environments[i].id == id,
      );
    }
    activeEnvironment.value = environments.cast<EnvironmentModel>().firstWhere(
      (e) => e.id == id,
      orElse: () => environments.first,
    );
    saveEnvironments();
  }

  void addEnvironmentVariable(String envId, String key, String value) {
    final index = environments.indexWhere((e) => e.id == envId);
    if (index != -1) {
      final newVars = Map<String, String>.from(environments[index].variables);
      newVars[key] = value;
      environments[index] = environments[index].copyWith(
        variables: newVars,
        updatedAt: DateTime.now(),
      );
      saveEnvironments();
    }
  }

  void updateEnvironmentVariable(
    String envId,
    String oldKey,
    String newKey,
    String value,
  ) {
    final index = environments.indexWhere((e) => e.id == envId);
    if (index != -1) {
      final newVars = Map<String, String>.from(environments[index].variables);
      newVars.remove(oldKey);
      newVars[newKey] = value;
      environments[index] = environments[index].copyWith(
        variables: newVars,
        updatedAt: DateTime.now(),
      );
      saveEnvironments();
    }
  }

  void deleteEnvironmentVariable(String envId, String key) {
    final index = environments.indexWhere((e) => e.id == envId);
    if (index != -1) {
      final newVars = Map<String, String>.from(environments[index].variables);
      newVars.remove(key);
      environments[index] = environments[index].copyWith(
        variables: newVars,
        updatedAt: DateTime.now(),
      );
      saveEnvironments();
    }
  }

  void addGlobalVariable(String key, String value) {
    final newVars = Map<String, String>.from(globalVariables.value.variables);
    newVars[key] = value;
    globalVariables.value = globalVariables.value.copyWith(
      variables: newVars,
      updatedAt: DateTime.now(),
    );
    saveGlobalVariables();
  }

  void updateGlobalVariable(String oldKey, String newKey, String value) {
    final newVars = Map<String, String>.from(globalVariables.value.variables);
    newVars.remove(oldKey);
    newVars[newKey] = value;
    globalVariables.value = globalVariables.value.copyWith(
      variables: newVars,
      updatedAt: DateTime.now(),
    );
    saveGlobalVariables();
  }

  void deleteGlobalVariable(String key) {
    final newVars = Map<String, String>.from(globalVariables.value.variables);
    newVars.remove(key);
    globalVariables.value = globalVariables.value.copyWith(
      variables: newVars,
      updatedAt: DateTime.now(),
    );
    saveGlobalVariables();
  }

  static bool isBaseUrlVariable(String name) {
    final normalized = name.toLowerCase().replaceAll('-', '_');
    return normalized == 'baseurl' || normalized == 'base_url';
  }

  static const List<String> baseUrlVariableKeys = [
    'baseUrl',
    'base_url',
    'BASE_URL',
    'BASEURL',
  ];

  String? _lookupVariableValue(
    String varName, {
    Map<String, String>? overrides,
  }) {
    if (overrides != null) {
      for (final entry in overrides.entries) {
        if (entry.key.toLowerCase() == varName.toLowerCase() &&
            entry.value.isNotEmpty) {
          return entry.value;
        }
      }
    }

    if (isBaseUrlVariable(varName)) {
      for (final key in baseUrlVariableKeys) {
        if (overrides != null) {
          final override = overrides[key];
          if (override != null && override.isNotEmpty) return override;
        }
        if (activeEnvironment.value != null) {
          final envValue = activeEnvironment.value!.getVariable(key);
          if (envValue != null && envValue.isNotEmpty) return envValue;
        }
        final globalValue = globalVariables.value.variables[key];
        if (globalValue != null && globalValue.isNotEmpty) return globalValue;
      }
      return null;
    }

    if (overrides != null) {
      final override = overrides[varName];
      if (override != null && override.isNotEmpty) return override;
    }

    if (activeEnvironment.value != null) {
      final envValue = activeEnvironment.value!.getVariable(varName);
      if (envValue != null && envValue.isNotEmpty) return envValue;
    }

    final globalValue = globalVariables.value.variables[varName];
    if (globalValue != null && globalValue.isNotEmpty) return globalValue;

    return null;
  }

  /// Replace {{variable}} placeholders with actual values.
  /// [overrides] are applied first (e.g. collection base URL for baseUrl/base_url).
  String replaceVariables(
    String input, {
    Map<String, String>? overrides,
  }) {
    if (!input.contains('{{')) return input;

    final regex = RegExp(r'\{\{\s*([^{}]+?)\s*\}\}');

    return input.replaceAllMapped(regex, (match) {
      final varName = match.group(1)!.trim();
      final value = _lookupVariableValue(varName, overrides: overrides);
      return value ?? match.group(0)!;
    });
  }

  /// Export environment to JSON
  String exportEnvironment(String envId) {
    final envIndex = environments.indexWhere((e) => e.id == envId);
    final env = envIndex != -1 ? environments[envIndex] : null;
    if (env == null) return '{}';
    return jsonEncode(env.toJson());
  }

  /// Import environment from JSON
  void importEnvironment(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final env = EnvironmentModel.fromJson(json);
      // Generate new ID to avoid conflicts
      final newEnv = env.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      environments.add(newEnv);
      saveEnvironments();
      showNotification('Environment imported successfully', 'success');
    } catch (e) {
      showNotification('Failed to import environment: $e', 'error');
    }
  }
}
