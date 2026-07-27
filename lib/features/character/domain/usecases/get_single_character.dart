import '../entities/character_entity.dart';
import '../repositories/character_repository.dart';

class GetSingleCharacterUseCase {
  final CharacterRepository repository;

  GetSingleCharacterUseCase({required this.repository});

  Future<CharacterEntity> call(int id) async {
    return await repository.getSingleCharacter(id);
  }
}
