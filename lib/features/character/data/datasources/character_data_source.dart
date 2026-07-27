import '../models/character_model.dart';
import '../models/character_response_model.dart';

abstract class CharacterDataSource {
  Future<CharacterResponseModel> getCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? type,
  });

  Future<CharacterModel> getSingleCharacter(int id);
  Future<List<CharacterModel>> getMultipleCharacters(List<int> ids);
}
