import '../entities/character_entity.dart';

class CharacterFetchResult {
  final List<CharacterEntity> characters;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;

  const CharacterFetchResult({
    required this.characters,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
  });
}

abstract class CharacterRepository {
  Future<CharacterFetchResult> getCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? type,
  });

  Future<CharacterEntity> getSingleCharacter(int id);

  Future<List<CharacterEntity>> getMultipleCharacters(List<int> ids);
}

