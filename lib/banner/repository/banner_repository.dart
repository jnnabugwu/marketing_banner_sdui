import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketing_banner_sdui/banner/models/banner_config.dart';

/// Thrown when banner fetch fails
class BannerFetchException implements Exception {
  const BannerFetchException([this.message]);
  final String? message;

  @override
  String toString() => 'BannerFetchException: ${message ?? 'Unknown error'}';
}

/// Repository for fetching banner configurations
class BannerRepository {
  BannerRepository({
    http.Client? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _baseUrl = baseUrl ?? 'http://localhost:8000';

  final http.Client _httpClient;
  final String _baseUrl;

  /// Fetches banner configuration for the given type
  Future<BannerConfig> fetchBanner(String bannerType) async {
    try {
      final uri = Uri.parse('$_baseUrl/banner_$bannerType.json');
      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        throw BannerFetchException(
          'Failed to fetch banner: ${response.statusCode}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return BannerConfig.fromJson(json);
    } catch (error) {
      throw BannerFetchException('Failed to fetch banner: $error');
    }
  }

  /// Fetches all available banners
  Future<List<BannerConfig>> fetchAllBanners() async {
    try {
      final uri = Uri.parse('$_baseUrl/banners.json');
      final response = await _httpClient.get(uri);

      if (response.statusCode != 200) {
        throw BannerFetchException(
          'Failed to fetch banners: ${response.statusCode}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final bannersList = json['banners'] as List<dynamic>;

      return bannersList
          .map((e) => BannerConfig.fromJson(e as Map<String, dynamic>))
          .where((banner) => banner.isValid)
          .toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
    } catch (error) {
      throw BannerFetchException('Failed to fetch banners: $error');
    }
  }
}
