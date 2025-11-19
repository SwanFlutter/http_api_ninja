import 'http_request_model.dart';

class CollectionModel {
  final String id;
  final String name;
  final List<HttpRequestModel> requests;
  final bool isExpanded;

  CollectionModel({
    required this.id,
    required this.name,
    this.requests = const [],
    this.isExpanded = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'requests': requests.map((r) => r.toJson()).toList(),
    'isExpanded': isExpanded,
  };

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      CollectionModel(
        id: json['id'],
        name: json['name'],
        requests:
            (json['requests'] as List?)
                ?.map((r) => HttpRequestModel.fromJson(r))
                .toList() ??
            [],
        isExpanded: json['isExpanded'] ?? true,
      );

  CollectionModel copyWith({
    String? id,
    String? name,
    List<HttpRequestModel>? requests,
    bool? isExpanded,
  }) => CollectionModel(
    id: id ?? this.id,
    name: name ?? this.name,
    requests: requests ?? this.requests,
    isExpanded: isExpanded ?? this.isExpanded,
  );
}
