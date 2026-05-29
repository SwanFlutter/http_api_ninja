import 'dart:convert';

/// Generates model/type definitions from JSON response bodies.
class TypeGenerator {
  static const languages = ['Dart', 'TypeScript', 'C#', 'Python', 'Java', 'Kotlin'];

  static String generate(String language, dynamic jsonBody) {
    final Map<String, dynamic>? root = _normalizeRoot(jsonBody);
    if (root == null) {
      return '// No JSON object/array in response body to generate types from.\n'
          '// Send a request that returns JSON first.';
    }

    switch (language) {
      case 'Dart':
        return _dart(root);
      case 'TypeScript':
        return _typescript(root);
      case 'C#':
        return _csharp(root);
      case 'Python':
        return _python(root);
      case 'Java':
        return _java(root);
      case 'Kotlin':
        return _kotlin(root);
      default:
        return _dart(root);
    }
  }

  static Map<String, dynamic>? _normalizeRoot(dynamic body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return Map<String, dynamic>.from(body);
    if (body is String) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
          return {'data': decoded};
        }
      } catch (_) {}
    }
    if (body is List && body.isNotEmpty && body.first is Map) {
      return {'items': body};
    }
    return null;
  }

  static String _dart(Map<String, dynamic> root) {
    final buffer = StringBuffer('// Generated Dart models\n\n');
    _emitDartClass(buffer, 'ApiResponse', root, 0);
    return buffer.toString();
  }

  static void _emitDartClass(
    StringBuffer buffer,
    String className,
    Map<String, dynamic> map,
    int depth,
  ) {
    buffer.writeln('class $className {');
    for (final entry in map.entries) {
      final field = _safeName(entry.key);
      final type = _dartType(entry.value, '${className}_$field', buffer, depth);
      buffer.writeln('  final $type $field;');
    }
    buffer.writeln();
    buffer.writeln('  $className({');
    for (final entry in map.entries) {
      buffer.writeln('    required this.${_safeName(entry.key)},');
    }
    buffer.writeln('  });');
    buffer.writeln();
    buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
    buffer.writeln('    return $className(');
    for (final entry in map.entries) {
      final field = _safeName(entry.key);
      final key = entry.key;
      if (entry.value is Map) {
        buffer.writeln(
          '      $field: ${className}_$field.fromJson(json[\'$key\'] as Map<String, dynamic>),',
        );
      } else if (entry.value is List &&
          entry.value is List &&
          (entry.value as List).isNotEmpty &&
          (entry.value as List).first is Map) {
        buffer.writeln(
          '      $field: (json[\'$key\'] as List).map((e) => ${className}_${field}Item.fromJson(e as Map<String, dynamic>)).toList(),',
        );
      } else {
        buffer.writeln('      $field: json[\'$key\'] as ${_dartType(entry.value, '', buffer, depth)},');
      }
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln();
  }

  static String _dartType(
    dynamic value,
    String nestedName,
    StringBuffer buffer,
    int depth,
  ) {
    if (value == null) return 'dynamic';
    if (value is bool) return 'bool';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is String) return 'String';
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      final first = value.first;
      if (first is Map<String, dynamic>) {
        if (depth < 3) _emitDartClass(buffer, '${nestedName}Item', first, depth + 1);
        return 'List<${nestedName}Item>';
      }
      return 'List<${_dartType(first, nestedName, buffer, depth)}>';
    }
    if (value is Map) {
      if (depth < 3) {
        _emitDartClass(buffer, nestedName, Map<String, dynamic>.from(value), depth + 1);
      }
      return nestedName;
    }
    return 'dynamic';
  }

  static String _typescript(Map<String, dynamic> root) {
    final buffer = StringBuffer('// Generated TypeScript interfaces\n\n');
    _emitTsInterface(buffer, 'ApiResponse', root, 0);
    return buffer.toString();
  }

  static void _emitTsInterface(
    StringBuffer buffer,
    String name,
    Map<String, dynamic> map,
    int depth,
  ) {
    buffer.writeln('export interface $name {');
    for (final entry in map.entries) {
      final optional = entry.value == null ? '?' : '';
      buffer.writeln(
        '  ${_safeName(entry.key)}$optional: ${_tsType(entry.value, '${name}_${_safeName(entry.key)}', buffer, depth)};',
      );
    }
    buffer.writeln('}');
    buffer.writeln();
  }

  static String _tsType(
    dynamic value,
    String nestedName,
    StringBuffer buffer,
    int depth,
  ) {
    if (value == null) return 'unknown';
    if (value is bool) return 'boolean';
    if (value is num) return 'number';
    if (value is String) return 'string';
    if (value is List) {
      if (value.isEmpty) return 'unknown[]';
      return '${_tsType(value.first, nestedName, buffer, depth)}[]';
    }
    if (value is Map) {
      if (depth < 3) {
        _emitTsInterface(buffer, nestedName, Map<String, dynamic>.from(value), depth + 1);
      }
      return nestedName;
    }
    return 'unknown';
  }

  static String _csharp(Map<String, dynamic> root) {
    final buffer = StringBuffer(
      '// Generated C# classes\nusing System.Collections.Generic;\n\n',
    );
    _emitCsharpClass(buffer, 'ApiResponse', root, 0);
    return buffer.toString();
  }

  static void _emitCsharpClass(
    StringBuffer buffer,
    String name,
    Map<String, dynamic> map,
    int depth,
  ) {
    buffer.writeln('public class $name');
    buffer.writeln('{');
    for (final entry in map.entries) {
      buffer.writeln(
        '    public ${_csharpType(entry.value)} ${_pascalCase(_safeName(entry.key))} { get; set; }',
      );
    }
    buffer.writeln('}');
    buffer.writeln();
  }

  static String _csharpType(dynamic value) {
    if (value == null) return 'object?';
    if (value is bool) return 'bool';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is String) return 'string';
    if (value is List) return 'List<object>';
    if (value is Map) return 'Dictionary<string, object>';
    return 'object';
  }

  static String _python(Map<String, dynamic> root) {
    final buffer = StringBuffer(
      '# Generated Python dataclasses\nfrom dataclasses import dataclass\nfrom typing import Any, Optional\n\n',
    );
    buffer.writeln('@dataclass');
    buffer.writeln('class ApiResponse:');
    for (final entry in root.entries) {
      buffer.writeln('    ${_safeName(entry.key)}: ${_pythonType(entry.value)}');
    }
    return buffer.toString();
  }

  static String _pythonType(dynamic value) {
    if (value == null) return 'Optional[Any]';
    if (value is bool) return 'bool';
    if (value is int) return 'int';
    if (value is double) return 'float';
    if (value is String) return 'str';
    if (value is List) return 'list';
    if (value is Map) return 'dict';
    return 'Any';
  }

  static String _java(Map<String, dynamic> root) {
    final buffer = StringBuffer('// Generated Java classes\n\n');
    buffer.writeln('public class ApiResponse {');
    for (final entry in root.entries) {
      buffer.writeln(
        '    public ${_javaType(entry.value)} ${_safeName(entry.key)};',
      );
    }
    buffer.writeln('}');
    return buffer.toString();
  }

  static String _kotlin(Map<String, dynamic> root) {
    final buffer = StringBuffer('// Generated Kotlin data class\n\n');
    buffer.writeln('data class ApiResponse(');
    final fields = root.entries.map((e) {
      return '    val ${_safeName(e.key)}: ${_kotlinType(e.value)}? = null';
    }).join(',\n');
    buffer.writeln(fields);
    buffer.writeln(')');
    return buffer.toString();
  }

  static String _javaType(dynamic value) {
    if (value == null) return 'Object';
    if (value is bool) return 'boolean';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is String) return 'String';
    if (value is List) return 'List<Object>';
    if (value is Map) return 'Map<String, Object>';
    return 'Object';
  }

  static String _kotlinType(dynamic value) {
    if (value == null) return 'Any';
    if (value is bool) return 'Boolean';
    if (value is int) return 'Int';
    if (value is double) return 'Double';
    if (value is String) return 'String';
    if (value is List) return 'List<Any>';
    if (value is Map) return 'Map<String, Any>';
    return 'Any';
  }

  static String _safeName(String key) {
    var name = key.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    if (name.isEmpty) name = 'field';
    if (RegExp(r'^[0-9]').hasMatch(name)) name = 'f_$name';
    return name;
  }

  static String _pascalCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
