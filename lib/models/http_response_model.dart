class HttpResponseModel {
  final int statusCode;
  final String statusMessage;
  final Map<String, String> headers;
  final dynamic body;
  final int size;
  final int time;
  final DateTime timestamp;

  HttpResponseModel({
    required this.statusCode,
    required this.statusMessage,
    required this.headers,
    required this.body,
    required this.size,
    required this.time,
    required this.timestamp,
  });

  String get statusText => '$statusCode $statusMessage';
  String get sizeText => '${(size / 1024).toStringAsFixed(2)} KB';
  String get timeText => '$time ms';

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'statusMessage': statusMessage,
    'headers': headers,
    'body': body,
    'size': size,
    'time': time,
    'timestamp': timestamp.toIso8601String(),
  };

  factory HttpResponseModel.fromJson(Map<String, dynamic> json) =>
      HttpResponseModel(
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
        headers: Map<String, String>.from(json['headers'] ?? {}),
        body: json['body'],
        size: json['size'],
        time: json['time'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
