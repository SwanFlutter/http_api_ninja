class HttpRequestModel {
  final String id;
  final String name;
  final String method;
  final String url;
  final Map<String, String> headers;
  final Map<String, String> queryParams;
  final String? body;
  final String? authType;
  final Map<String, String>? authData;
  final DateTime createdAt;
  final DateTime? lastUsed;

  HttpRequestModel({
    required this.id,
    required this.name,
    required this.method,
    required this.url,
    this.headers = const {},
    this.queryParams = const {},
    this.body,
    this.authType,
    this.authData,
    required this.createdAt,
    this.lastUsed,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'method': method,
    'url': url,
    'headers': headers,
    'queryParams': queryParams,
    'body': body,
    'authType': authType,
    'authData': authData,
    'createdAt': createdAt.toIso8601String(),
    'lastUsed': lastUsed?.toIso8601String(),
  };

  factory HttpRequestModel.fromJson(Map<String, dynamic> json) =>
      HttpRequestModel(
        id: json['id'],
        name: json['name'],
        method: json['method'],
        url: json['url'],
        headers: Map<String, String>.from(json['headers'] ?? {}),
        queryParams: Map<String, String>.from(json['queryParams'] ?? {}),
        body: json['body'],
        authType: json['authType'],
        authData: json['authData'] != null
            ? Map<String, String>.from(json['authData'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        lastUsed: json['lastUsed'] != null
            ? DateTime.parse(json['lastUsed'])
            : null,
      );

  HttpRequestModel copyWith({
    String? id,
    String? name,
    String? method,
    String? url,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    String? body,
    String? authType,
    Map<String, String>? authData,
    DateTime? createdAt,
    DateTime? lastUsed,
  }) => HttpRequestModel(
    id: id ?? this.id,
    name: name ?? this.name,
    method: method ?? this.method,
    url: url ?? this.url,
    headers: headers ?? this.headers,
    queryParams: queryParams ?? this.queryParams,
    body: body ?? this.body,
    authType: authType ?? this.authType,
    authData: authData ?? this.authData,
    createdAt: createdAt ?? this.createdAt,
    lastUsed: lastUsed ?? this.lastUsed,
  );
}
