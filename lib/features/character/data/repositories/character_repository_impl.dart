import '../../domain/entities/character_entity.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_data_source.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterDataSource dataSource;

  CharacterRepositoryImpl({required this.dataSource});

  @override
  Future<CharacterFetchResult> getCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? type,
  }) async {
    final response = await dataSource.getCharacters(
      page: page,
      name: name,
      status: status,
      species: species,
      gender: gender,
      type: type,
    );

    return CharacterFetchResult(
      characters: response.results,
      totalCount: response.totalCount,
      totalPages: response.totalPages,
      hasNextPage: response.nextPageUrl != null,
    );
  }

  @override
  Future<CharacterEntity> getSingleCharacter(int id) async {
    return await dataSource.getSingleCharacter(id);
  }

  @override
  Future<List<CharacterEntity>> getMultipleCharacters(List<int> ids) async {
    return await dataSource.getMultipleCharacters(ids);
  }
}
