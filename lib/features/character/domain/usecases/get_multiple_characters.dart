import '../entities/character_entity.dart';
import '../repositories/character_repository.dart';

class GetMultipleCharactersUseCase {
  final CharacterRepository repository;

  GetMultipleCharactersUseCase({required this.repository});

  Future<List<CharacterEntity>> call(List<int> ids) async {
    return await repository.getMultipleCharacters(ids);
  }
}
