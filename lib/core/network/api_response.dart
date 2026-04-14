import 'package:dio/dio.dart';

class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final Map<String, dynamic>? meta;

  const ApiResponse({
    this.data,
    this.message,
    this.success = true,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse(
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? true,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final bool hasMore;

  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    required this.hasMore,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final meta = json['meta'] as Map<String, dynamic>? ?? json;
    final dataList = (json['data'] as List<dynamic>?) ?? [];

    final currentPage = meta['current_page'] as int? ?? 1;
    final lastPage = meta['last_page'] as int? ?? 1;

    return PaginatedResponse(
      data: dataList
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: currentPage,
      lastPage: lastPage,
      total: meta['total'] as int? ?? dataList.length,
      perPage: meta['per_page'] as int? ?? 20,
      hasMore: currentPage < lastPage,
    );
  }
}
