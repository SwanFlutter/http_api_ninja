/// Model for Environment Variables
class EnvironmentModel {
  final String id;
  final String name;
  final Map<String, String> variables;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  EnvironmentModel({
    required this.id,
    required this.name,
    this.variables = const {},
    this.isActive = false,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'variables': variables,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory EnvironmentModel.fromJson(Map<String, dynamic> json) =>
      EnvironmentModel(
        id: json['id'],
        name: json['name'],
        variables: Map<String, String>.from(json['variables'] ?? {}),
        isActive: json['isActive'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null 
            ? DateTime.parse(json['updatedAt']) 
            : null,
      );

  EnvironmentModel copyWith({
    String? id,
    String? name,
    Map<String, String>? variables,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EnvironmentModel(
    id: id ?? this.id,
    name: name ?? this.name,
    variables: variables ?? this.variables,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Get variable value by key
  String? getVariable(String key) => variables[key];

  /// Check if variable exists
  bool hasVariable(String key) => variables.containsKey(key);
}

/// Model for Global Variables (shared across all environments)
class GlobalVariablesModel {
  final Map<String, String> variables;
  final DateTime? updatedAt;

  GlobalVariablesModel({
    this.variables = const {},
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'variables': variables,
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory GlobalVariablesModel.fromJson(Map<String, dynamic> json) =>
      GlobalVariablesModel(
        variables: Map<String, String>.from(json['variables'] ?? {}),
        updatedAt: json['updatedAt'] != null 
            ? DateTime.parse(json['updatedAt']) 
            : null,
      );

  GlobalVariablesModel copyWith({
    Map<String, String>? variables,
    DateTime? updatedAt,
  }) => GlobalVariablesModel(
    variables: variables ?? this.variables,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
