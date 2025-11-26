/// Model for Request History
class HistoryModel {
  final String id;
  final String method;
  final String url;
  final Map<String, String> headers;
  final Map<String, String> queryParams;
  final String? body;
  final int? statusCode;
  final String? statusMessage;
  final int? responseTime;
  final int? responseSize;
  final DateTime timestamp;
  final String? collectionId;
  final String? requestName;

  HistoryModel({
    required this.id,
    required this.method,
    required this.url,
    this.headers = const {},
    this.queryParams = const {},
    this.body,
    this.statusCode,
    this.statusMessage,
    this.responseTime,
    this.responseSize,
    required this.timestamp,
    this.collectionId,
    this.requestName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'method': method,
    'url': url,
    'headers': headers,
    'queryParams': queryParams,
    'body': body,
    'statusCode': statusCode,
    'statusMessage': statusMessage,
    'responseTime': responseTime,
    'responseSize': responseSize,
    'timestamp': timestamp.toIso8601String(),
    'collectionId': collectionId,
    'requestName': requestName,
  };

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    id: json['id'],
    method: json['method'],
    url: json['url'],
    headers: Map<String, String>.from(json['headers'] ?? {}),
    queryParams: Map<String, String>.from(json['queryParams'] ?? {}),
    body: json['body'],
    statusCode: json['statusCode'],
    statusMessage: json['statusMessage'],
    responseTime: json['responseTime'],
    responseSize: json['responseSize'],
    timestamp: DateTime.parse(json['timestamp']),
    collectionId: json['collectionId'],
    requestName: json['requestName'],
  );

  HistoryModel copyWith({
    String? id,
    String? method,
    String? url,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    String? body,
    int? statusCode,
    String? statusMessage,
    int? responseTime,
    int? responseSize,
    DateTime? timestamp,
    String? collectionId,
    String? requestName,
  }) => HistoryModel(
    id: id ?? this.id,
    method: method ?? this.method,
    url: url ?? this.url,
    headers: headers ?? this.headers,
    queryParams: queryParams ?? this.queryParams,
    body: body ?? this.body,
    statusCode: statusCode ?? this.statusCode,
    statusMessage: statusMessage ?? this.statusMessage,
    responseTime: responseTime ?? this.responseTime,
    responseSize: responseSize ?? this.responseSize,
    timestamp: timestamp ?? this.timestamp,
    collectionId: collectionId ?? this.collectionId,
    requestName: requestName ?? this.requestName,
  );

  /// Check if request was successful
  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;

  /// Get formatted timestamp
  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
