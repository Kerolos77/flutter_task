class ApiEndpoints {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String characters = '/character';

  static String singleCharacter(int id) => '/character/$id';
  static String multipleCharacters(List<int> ids) => '/character/${ids.join(',')}';
}
