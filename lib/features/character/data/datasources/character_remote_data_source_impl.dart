import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/character_model.dart';
import '../models/character_response_model.dart';
import 'character_data_source.dart';

class CharacterRemoteDataSourceImpl implements CharacterDataSource {
  final ApiClient apiClient;

  CharacterRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CharacterResponseModel> getCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
    };
    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (species != null && species.isNotEmpty) queryParams['species'] = species;
    if (gender != null && gender.isNotEmpty) queryParams['gender'] = gender;
    if (type != null && type.isNotEmpty) queryParams['type'] = type;

    final response = await apiClient.get(ApiEndpoints.characters, queryParameters: queryParams);
    return CharacterResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CharacterModel> getSingleCharacter(int id) async {
    final response = await apiClient.get(ApiEndpoints.singleCharacter(id));
    return CharacterModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<CharacterModel>> getMultipleCharacters(List<int> ids) async {
    final response = await apiClient.get(ApiEndpoints.multipleCharacters(ids));
    final List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList.map((e) => CharacterModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
