import 'character_model.dart';

class CharacterResponseModel {
  final int totalPages;
  final int totalCount;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final List<CharacterModel> results;

  const CharacterResponseModel({
    required this.totalPages,
    required this.totalCount,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.results,
  });

  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    final info = json['info'] as Map<String, dynamic>? ?? {};
    final resultsList = json['results'] as List<dynamic>? ?? [];

    return CharacterResponseModel(
      totalPages: info['pages'] as int? ?? 1,
      totalCount: info['count'] as int? ?? 0,
      nextPageUrl: info['next'] as String?,
      prevPageUrl: info['prev'] as String?,
      results: resultsList
          .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
