import '../repositories/character_repository.dart';

class GetCharactersParams {
  final int page;
  final String? name;
  final String? status;
  final String? species;
  final String? gender;
  final String? type;

  const GetCharactersParams({
    this.page = 1,
    this.name,
    this.status,
    this.species,
    this.gender,
    this.type,
  });
}

class GetCharactersUseCase {
  final CharacterRepository repository;

  GetCharactersUseCase({required this.repository});

  Future<CharacterFetchResult> call(GetCharactersParams params) async {
    return await repository.getCharacters(
      page: params.page,
      name: params.name,
      status: params.status,
      species: params.species,
      gender: params.gender,
      type: params.type,
    );
  }
}
